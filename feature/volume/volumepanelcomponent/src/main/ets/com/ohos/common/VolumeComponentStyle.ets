/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { ResUtils } from '@ohos/windowscene';
import curves from '@ohos.curves';
import { AnimationSegment } from '@ohos/lottie';
import Constants from './Constants';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';


const getVolumePopupFontSize = (): number => {
  try {
    return ArkUIAdapter.px2vp(getContext().resourceManager.getNumber($r('sys.float.ohos_id_text_size_body2').id));
  } catch (e) {
    return Constants.DEFAULT_POPUP_FONT_SIZE; // 默认气泡字体大小
  }
}

export default class VolumeComponentStyle {
  public volumeProgressComponentWidth: number = ResUtils.getNumberFromLength($r('app.float.volume_progress_component_width'));
  public volumeProgressComponentWidthThin: number =
  ResUtils.getNumberFromLength($r('app.float.volume_progress_component_width_thin'));
  public volumeProgressComponentWidthThinMin: number =
  ResUtils.getNumberFromLength($r('app.float.volume_progress_component_width_thin_min'));
  public volumeProgressComponentWidthThinMax: number =
  ResUtils.getNumberFromLength($r('app.float.volume_progress_component_width_thin_max'));
  public volumeProgressComponentHeight: number =
  ResUtils.getNumberFromLength($r('app.float.volume_progress_component_height'));
  public volumeProgressComponentHeightThinMin: number =
  ResUtils.getNumberFromLength($r('app.float.volume_progress_component_height_thin_min'));
  public volumeProgressComponentHeightMax: number =
  ResUtils.getNumberFromLength($r('app.float.volume_progress_component_height_thin_max'));
  public volumeStackHeightInNumber: number =
  ResUtils.getNumberFromLength($r('app.float.volume_virtual_progress_component_height'));
  public volumeProgressComponentHeightStretch: number =
    ResUtils.getNumberFromLength($r('app.float.volume_progress_component_height_stretch'));
  public volumeDialogWidthInNumber: number = ResUtils.getNumberFromLength($r('app.float.volume_panel_dialog_width'));
  public volumeDialogHeightInNumber: number = ResUtils.getNumberFromLength($r('app.float.volume_panel_dialog_height'));
  public volumePanelTextHeight: number = 18; // 音量条下发文本高度
  public volumePanelTextFontSize: number = 14; // 音量条下发文本字体大小
  public volumePanelTextFontSizeUG: number = 12; // 音量条维文时下发文本字体大小
  public volumePanelTextMinFontSize: number = 9; // 音量条下发文本字体最小字号 适配多语言
  public volumePopupFontSize: number = getVolumePopupFontSize(); // 音量条气泡字体大小
  public volumePanelTextMargin: number = 8; // 音量条与下发文本的间隔
  public volumeDialogInitWidth: number = 80;
  public volumeDialogInitThinWidth: number = 80; // 右侧间距16，padding：8
  public volumeDialogInitHeight: number = 154;
  public volumeDialogInitMarkAnchorY: number = 0;
  public volumeBarMaxWidth: number = 45;
  public volumeBarContainerHeight: number = 160; // 太高会盖住设置按钮导致点击无法响应 (vp)
  public volumeBarInitTranslationX: number = 56;
  public volumeMoreSettingTextHeight: number = 21; //  音量面板“更多设置”按钮高度
  public volumeMoreSettingTextTopMargin: number = 24; //  音量面板“更多设置”上外边距
  public volumeMoreSettingTextBottomMargin: number = 16; //  音量面板“更多设置”下外边距
  public volumeMoreSettingFontSize: number = 16; //  音量面板“更多设置”按钮字体大小
  public volumeStackInitOpacity: number = 0.15;
  public volumeWindowMaxOpacityDark: number = 0.4;
  public volumeWindowMaxOpacityLight: number = 0.2;
  public volumeContainerPadding: number = 8; // 用于增大细音量条响应区域
  public volumePanelTopMargin: number = 108;
  public volumePanelDragThreshold: number = 24; // 更多音量面板横滑距离阈值
  // 展开音量面上部设置高度展开
  public volumeSettingHeightExpand: number = (this.volumeDialogHeightInNumber -
    this.volumeBarContainerHeight - this.volumePanelTextMargin - this.volumePanelTextHeight) / 2;
  // 展开音量面上部设置高度单条
  public volumeSettingHeight: number = (this.volumeDialogHeightInNumber -
  this.volumeBarContainerHeight) / 2;
  public dialogMaxHeight: number = 183; // 展开音量面上部设置高度
  public popupHeight: number = 21; // popup高度
  public popupWidth: number = 182; // popup宽度
  public popupMargin: number = 12; // popup边距
  public popupArrowOffset: number = 169; // popup边距
  public volumeArrowWidth: number = 16; // arrow宽
  public volumeArrowHeight: number = 60; // arrow高
  public volumeArrowMargin: number = 60; // arrow边距
  public volumeBackgroundNormal: string = '#808080';
  public volumeBackgroundAboveLauncher: Resource = $r('app.color.volume_panel_stacking_color');
  // 音量面板背景色基准值,值不带#号
  public volumeBackgroundBaseColor: string = 'FF000000';
  public volumeBackgroundAboveLauncherColor: string = 'FF000000';
  public volumeBackgroundShadow: string = '#33000000';
  public volumeBgColor: string = '#33FAFAFA'; // 侧边音量条底色
  public volumeExpandBackgroundColor: Resource = $r('app.color.volume_panel_background_color'); // 面板背景色
  public volumeExpandProgressColor: Resource = $r('app.color.volume_panel_progress_color'); // 面板音量条进度
  public volumePanelDialogProgressColor: Resource = $r('app.color.volume_panel_bottom_color'); // 面板音量条底色
  public volumePanelProgressColor: Resource = $r('app.color.volume_side_progress_color'); // 侧边音量条进度
  public volumeExpandDialogProgressColor: Resource = $r('app.color.volume_side_bottom_default'); // 侧边音量条底色
  public volumePanelShadowColor: string = '#14000000';
  public volumeTitleHeight: number = 48; // 音量面板标题高度
  public volumeTitleMarginTop: number = 12; // 音量面板标题上方间距
  public volumeTitleMarginBottom: number = 8; // 音量面板标题下发间距
  public volumeTitleFontSize: number = 20; // 音量面板标题字体大小
  public volumeTitleFontColor: Resource = $r('app.color.volume_title_font_color'); // 音量面板标题字体颜色
  public volumeContentFontColor: Resource = $r('app.color.volume_content_font_color'); // 音量面板描述字体颜色
  public volumeFontColorBase: string = 'FF000000';
  public volumeFontColorDark: string = 'FFFFFFFF';
  public backgroundBlurColor: string = '#00000000';
  public backgroundBrightnessVolumeWhiteBg: string = 'FFFFFFFF';
  public backgroundBrightnessVolumeBlackBg: string = 'FF000000';
  public volumePanelRadio: number = 32; // 面板展开圆角度
  public springMotionDefault: ICurve = curves.springMotion(0.55, 0.825, 0);
  public springMotionMultiVolume: ICurve[] =
    [curves.springMotion(0.41, 0.83, 0), curves.springMotion(0.39, 0.83, 0), curves.springMotion(0.37, 0.83, 0)];
  public interpolatingSpringDefault: ICurve = curves.interpolatingSpring(0, 1, 228, 25);
  public interpolatingSpringThick2Thin: ICurve = curves.interpolatingSpring(0, 1, 228, 22);
  public interpolatingSpringThin2Thick: ICurve = curves.interpolatingSpring(0, 1, 228, 22);
  public interpolatingSpringThickDownStart: ICurve = curves.interpolatingSpring(0, 1, 228, 30);
  public interpolatingSpringThickDownStop: ICurve = curves.interpolatingSpring(0, 1, 228, 30);
  public interpolatingSpringVolumeProgress: ICurve = curves.interpolatingSpring(0, 1, 450, 40);
  public interpolatingKeyUpAndDown: ICurve = curves.interpolatingSpring(0, 1, 688, 52);
  public curveOpacityArrow: ICurve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);
  public curveTranslateXArrow: ICurve = curves.cubicBezierCurve(0.29, 0, 0.51, 1);
  public interpolatingSpringActive: ICurve = curves.interpolatingSpring(1, 1, 410, 38);
  public expandVolumeDurations: number[] = [100, 183, 267, 350];
  public responsiveSpringMotionVolumeProgress: ICurve = curves.responsiveSpringMotion(0.1, 1, 0);
  public defaultVolumeBarAlignRules: AlignRuleOption = {
    center: { anchor: '__container__', align: VerticalAlign.Center },
    right: { anchor: '__container__', align: HorizontalAlign.End },
  };
  public defaultVolumeBarMargin: Margin = {
    top: 0,
    bottom: 0,
  };
  /**
   * 媒体喇叭图标lottie动画各个等级关键帧
   * [43, 103]] 一档
   * [104, 156] 二档
   * [157, 206] 三档
   * [1, 42] 镜像一档关键帧
   */
  public mediaLottieKeyFrames: Array<AnimationSegment> = [[43, 103], [104, 156], [157, 206], [1, 42]];
  /**
   * 媒体喇叭图标lottie动画减音量各个等级关键帧
   */
  public mediaLottieKeyFramesReverse: Array<AnimationSegment> = [[313, 356], [254, 312], [207, 253], [357, 410]];
  // 音量条和音量面板阴影
  public volumeShadowOptions: ShadowOptions = {
    radius: 60,
    color: '#33000000',
    offsetX: 0,
    offsetY: 10,
  };

  static getVolumeComponentStyle(): VolumeComponentStyle {
    return new VolumeComponentStyle();
  }
}
