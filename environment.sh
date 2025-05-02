#!/bin/bash
# 若任何命令出错，则退出脚本
set -e

# ====== 1. 替换 apt 源为清华 TUNA 镜像（速度更快） ======
echo "📦 备份原始 APT 源..."
sudo cp /etc/apt/sources.list /etc/apt/sources.list.backup

echo "📥 替换为清华源 (TUNA)..."
sudo bash -c 'cat > /etc/apt/sources.list <<EOF
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ bionic main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ bionic-updates main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ bionic-backports main restricted universe multiverse
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ bionic-security main restricted universe multiverse
EOF'

echo "🔄 更新 APT 索引..."
sudo apt update

# ====== 2. 安装 C/C++ 图像处理与视频相关依赖 ======
# 图像解码、压缩支持库（Pillow、OpenCV 需要）
sudo apt install -y libfreetype6-dev zlib1g-dev
sudo apt install -y libjpeg-dev libtiff-dev libwebp-dev libpng-dev

# 并行处理（OpenCV 的 TBB 后端支持）
sudo apt install -y libtbb-dev

# GStreamer：视频流处理、用于 OpenCV VideoCapture/VideoWriter
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# GTK 图形窗口支持（OpenCV GUI 组件依赖）
sudo apt install -y libgtk-3-dev

# Cairo / Pango / Pixman 图形与字体渲染支持（某些 GUI 程序、图形工具链依赖）
sudo apt install -y libgdk-pixbuf2.0-dev libpango1.0-dev libpixman-1-dev libcairo2-dev

# FFmpeg: 音视频处理，OpenCV 视频读写功能依赖
sudo apt install -y ffmpeg

# ====== 3. 安装 FFmpeg 的底层编解码模块 ======
sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt install -y libv4l-dev libxvidcore-dev libx264-dev
sudo apt install -y libavresample-dev libavutil-dev libswresample-dev
sudo apt install -y libavdevice-dev libavfilter-dev

# ====== 4. 安装线性代数与数学优化相关库（OpenCV / 深度学习框架常用） ======
sudo apt install -y libatlas-base-dev       # ATLAS 数学库
sudo apt install -y libopenblas-dev libblas-dev  # BLAS 实现（OpenCV dnn 和 Torch 都会用到）
sudo apt install -y libhdf5-dev             # HDF5 数据格式支持（Keras/TensorFlow 常用）

# ====== 5. 安装 Protobuf 与 Glog、Gflags（ONNX、Caffe、Torchvision 编译需要） ======
sudo apt install -y protobuf-compiler libprotobuf-dev
sudo apt install -y libgoogle-glog-dev libgflags-dev

# ====== 6. 安装多线程与分布式支持库（OpenMP、MPI）=====
sudo apt install -y libopenmpi-dev libomp-dev

# ====== 7. 安装 Python 编译与依赖环境（略）=====
echo "🐍 安装 cython、numpy、pillow..."
sudo pip3 install cython==0.29.30
sudo pip3 install numpy==1.19.4
sudo pip3 install pillow==8.4.0
python3 -c "from PIL import Image; print('✅ Pillow 已安装，版本:', Image.__version__)"

# ====== 8. 安装 PyTorch ======
echo "🔥 安装 PyTorch（离线 .whl 包）"
sudo pip3 install ./torch-1.8.0-cp36-cp36m-linux_aarch64.whl
python3 -c "import torch; print(torch.__version__); print('CUDA 可用:', torch.cuda.is_available())"

# ====== 9. 安装 TorchVision（源码安装）=====
echo "🎨 安装 TorchVision"
echo 'export BUILD_VERSION=0.9.0' >> ~/.bashrc
source ~/.bashrc
tar -xzvf ./vision-0.9.0.tar.gz
cd vision-0.9.0
python3 setup.py install
cd ..
python3 -c "import torchvision; print('✅ torchvision 已安装，版本:', torchvision.__version__)"

# ====== 10. 安装 ONNX Runtime ======
echo "🧠 安装 ONNX Runtime（GPU版）"
sudo pip3 install ./onnxruntime_gpu-1.8.0-cp36-cp36m-linux_aarch64.whl

# ====== 11. 安装 PyQt5 + Qt 工具链 ======
echo "🪟 安装 PyQt5 与 Qt Designer 工具"
sudo apt install -y python3-pyqt5 pyqt5-dev-tools qt5-default qttools5-dev-tools
qmake --version
echo "👉 如需完整组件支持，请参考："
echo "https://blog.csdn.net/qq_63913621/article/details/136339370"

# ====== 12. 安装 OpenCV 4.7 (DNN CPU 版) ======
echo "📦 安装 OpenCV 4.7 (DNN CPU 版)"
cp ./opencv-4.7.0-ok.tar.gz ~/
cd ~
tar -xzvf opencv-4.7.0-ok.tar.gz
mkdir -p ~/opencv-4.7.0/build
cd ~/opencv-4.7.0/build

cmake -DCMAKE_BUILD_TYPE=RELEASE \
      -DENABLE_NEON=ON \
      -DWITH_EIGEN=ON \
      -DOPENCV_ENABLE_NONFREE=ON \
      -DEIGEN_INCLUDE_PATH=/usr/include/eigen3 \
      -DCMAKE_INSTALL_PREFIX=/usr/local \
      -DOPENCV_GENERATE_PKGCONFIG=ON \
      -DPYTHON_EXECUTABLE=/usr/bin/python3.6 \
      -DOPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.6/dist-packages ..

make -j3
sudo make install

python3 -c "import cv2; print('✅ OpenCV 版本:', cv2.__version__); print('CUDA 设备数:', cv2.cuda.getCudaEnabledDeviceCount())"

# ====== 完成提示 ======
echo "🎉 ✅ Jetson 部署环境配置已完成！"
``

