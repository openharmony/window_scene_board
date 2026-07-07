/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024. All rights reserved.
 */

const DEFAULT_ICON_TRAN_X = 12;
const DEFAULT_BANNER_HEIGHT = 66;
const DEFAULT_BANNER_WIDTH = 360;

/**
 * 形变相关参数
 */
@ObservedV2
export class NotificationBannerDeformState {
  /**
   * 横幅通知是否形变为悬浮窗
   */
  @Trace public bannerToFloating: boolean = false;
  /**
   * 横幅通知高度
   */
  @Trace public bannerHeight: number = DEFAULT_BANNER_HEIGHT;
  /**
   * 横幅通知宽度
   */
  @Trace public bannerWidth: number = DEFAULT_BANNER_WIDTH;
  /**
   * 横幅通知图标大小比例
   */
  @Trace public bannerIconScale: number = 1;
  /**
   * 横幅通知横向位移
   */
  @Trace public bannerTranX: number = 0;
  /**
   * 横幅通知纵向位移
   */
  @Trace public bannerTranY: number = 0;
  /**
   * 横幅通知图标横向位移
   */
  @Trace public bannerIconTranX: number = DEFAULT_ICON_TRAN_X;
  /**
   * 横幅通知图标纵向位移
   */
  @Trace public bannerIconTranY: number = 0;
  /**
   * 横幅通知内容不透明度
   */
  @Trace public bannerTextOpacity: number = 1;
  /**
   * 横幅通知蒙版不透明度
   */
  @Trace public bannerMaskingOpacity: number = 0;
  /**
   * 横幅通知蒙版可见性
   */
  @Trace public bannerMaskingVisibility: boolean = false;
  /**
   * 动效终点
   */
  @Trace public endTranY: number = -1;
  /**
   * 横幅通知整体不透明度
   */
  @Trace public bannerOpacity: number = 1;

  public equal(bannerDeformState: NotificationBannerDeformState): boolean {
    let sizeFlag = this.bannerHeight === bannerDeformState.bannerHeight &&
      this.bannerWidth === bannerDeformState.bannerWidth &&
      this.bannerIconScale === bannerDeformState.bannerIconScale;
    let translateFlag = this.bannerTranX === bannerDeformState.bannerTranX &&
      this.bannerTranY === bannerDeformState.bannerTranY &&
      this.bannerIconTranX === bannerDeformState.bannerIconTranX &&
      this.bannerIconTranY === bannerDeformState.bannerIconTranY;
    let opacityFlag = this.bannerTextOpacity === bannerDeformState.bannerTextOpacity &&
      this.bannerMaskingOpacity === bannerDeformState.bannerMaskingOpacity &&
      this.bannerMaskingVisibility === bannerDeformState.bannerMaskingVisibility &&
      this.bannerOpacity === bannerDeformState.bannerOpacity;

    return sizeFlag && translateFlag && opacityFlag;
  }

  public update(bannerDeformState: NotificationBannerDeformState): void {
    if (this.equal(bannerDeformState)) {
      return;
    }
    this.bannerToFloating = bannerDeformState.bannerToFloating;
    this.bannerHeight = bannerDeformState.bannerHeight;
    this.bannerWidth = bannerDeformState.bannerWidth;
    this.bannerIconScale = bannerDeformState.bannerIconScale;
    this.bannerTranX = bannerDeformState.bannerTranX;
    this.bannerTranY = bannerDeformState.bannerTranY;
    this.bannerIconTranX = bannerDeformState.bannerIconTranX;
    this.bannerIconTranY = bannerDeformState.bannerIconTranY;
    this.bannerTextOpacity = bannerDeformState.bannerTextOpacity;
    this.bannerMaskingOpacity = bannerDeformState.bannerMaskingOpacity;
    this.bannerMaskingVisibility = bannerDeformState.bannerMaskingVisibility;
    this.bannerOpacity = bannerDeformState.bannerOpacity;
  }

  public reset(): void {
    this.bannerToFloating = false;
    this.bannerHeight = 66;
    this.bannerWidth = 360;
    this.bannerIconScale = 1;
    this.bannerTranX = 0;
    this.bannerTranY = 0;
    this.bannerIconTranX = 12;
    this.bannerIconTranY = 0;
    this.bannerTextOpacity = 1;
    this.bannerMaskingOpacity = 0;
    this.bannerMaskingVisibility = false;
    this.bannerOpacity = 1;
  }
}