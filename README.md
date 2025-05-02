# 某福师大·22级人工智能方向 —— Jetson嵌入式环境一键安装脚本

本项目提供了一份适用于 **Jetson平台（如 Xavier / Nano）** 的一键环境部署脚本，  
专为 **2022级人工智能专业嵌入式方向** 打造，覆盖图像处理、深度学习、推理优化等全流程所需组件。

## 📌 安装内容概览

该脚本将自动完成以下组件的安装与配置：

- 🎯 更换为清华大学 APT 软件源（提高下载速度）
- 🔧 安装系统依赖（OpenCV、PyTorch、TorchVision 编译相关）
- 🔍 安装基础图像/视频编解码库（FFmpeg、GStreamer、libjpeg 等）
- 🔢 安装加速计算库（OpenBLAS、ATLAS、OpenMPI）
- 🔬 安装深度学习框架：
  - PyTorch 1.8.0（离线 ARM 架构专用 whl 包）
  - TorchVision 0.9.0（源码安装）
  - ONNX Runtime 1.8.0（GPU 加速版）
- 📷 安装 OpenCV 4.7.0（支持 DNN 模块，无需 CUDA）
- 🖼️ 安装 PyQt5 与 Qt Designer 工具（用于构建桌面视觉界面）

---

## 🚀 快速开始

1. **准备脚本文件与依赖包**

请确保你已经将以下文件准备好，并放置在当前目录：

- `environment.sh`（本项目中的主脚本）
- `torch-1.8.0-cp36-cp36m-linux_aarch64.whl`
- `vision-0.9.0.tar.gz`
- `onnxruntime_gpu-1.8.0-cp36-cp36m-linux_aarch64.whl`
- `opencv-4.7.0-ok.tar.gz`

2. **赋予脚本执行权限**

```bash
chmod +x environment.sh
````

3. **运行一键安装脚本**

```bash
sudo bash environment.sh
```

> 📎 请确保你已连接网络，且具有 sudo 权限。

---

## 🧠 适配平台说明

* ✅ Ubuntu 18.04（JetPack 4.x）推荐
* ✅ Jetson Nano / TX2 / Xavier NX 等 ARM64 架构

---

## 📂 安装完成后检查方法

你可以使用以下命令检查环境是否配置成功：

```bash
python3 -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
python3 -c "import torchvision; print(torchvision.__version__)"
python3 -c "import cv2; print(cv2.__version__)"
```

---

## ✍️ 作者信息

* 🎓 某福师大 · 人工智能专业 22级
* 👨‍💻 用心打造的嵌入式一键环境部署方案
* 📫 教学 & 技术支持请联系辅导员 / 指导老师

---

## 📌 注意事项

* 本脚本覆盖系统 `sources.list`，请谨慎操作，首次运行时自动备份。
* 若需要更高版本的 PyTorch / OpenCV，请手动源码编译并替换脚本路径。

---

## 🏁 欢迎使用并传播！让每一位 AI 同学都能轻松搞定环境！



