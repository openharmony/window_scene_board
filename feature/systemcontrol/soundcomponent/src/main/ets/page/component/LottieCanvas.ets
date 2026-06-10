/*
 * Copyright (c) Huawei Device Co., Ltd. 2023-2023. All rights reserved.
 */

import lottie from '@ohos/lottie';

/**
 * lottie动画组件
 * @param path 动画路径（动画需要的json文件放到pages同级别目录，json文件路径不能使用 ./ 或者 ../ 等相对路径，相对路径获取不到动画源数据）
 * @param loop 是否循环，传布尔/循环次数
 * @param speed 动画速度，默认1
 * @param name 动画名 用于播放销毁动画用
 */

@Component
export default struct LottieCanvas {
  private mainRenderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(this.mainRenderingSettings);
  @Prop animationData?: object;
  @Prop name: string = 'lottieCanvas';
  @Prop canvasScale: number = 1;
  aboutToDisappear() {
    // 组件销毁时手动释放lottie资源
    lottie.destroy(this.name);
  }

  build() {
    Canvas(this.mainCanvasRenderingContext)
      .width(40)
      .height(40)
      .scale({ x: this.canvasScale, y: this.canvasScale })
      .onReady(() => {
        lottie.loadAnimation({
          container: this.mainCanvasRenderingContext, // 渲染上下文
          renderer: 'canvas', // 渲染方式
          autoplay: false, // 是否自动播放，默认false
          animationData: this.animationData, // json路径
          loop: false,
          name: this.name,
        });
        lottie.play(this.name);
      })
      .onDisAppear(() => {
        lottie.destroy(this.name);
      })
  }
}
;