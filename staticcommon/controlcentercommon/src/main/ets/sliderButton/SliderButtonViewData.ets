/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { curves } from '@kit.ArkUI';
import { SingletonHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { RTLUtil } from '@ohos/componenthelper';
import { AnimationSegment } from '@ohos/lottie';

/**
 * 滑动条开关视效配置类
 */
export class SliderButtonViewData {
  public buttonWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_width'));
  public buttonHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_height'));
  public sliderWidth: number = ResUtils.getConvertNumber($r('app.float.Control_center_slider_width'));
  public sliderHeight: number = ResUtils.getConvertNumber($r('app.float.Control_center_slider_height'));
  public subpageSliderScale: number = 0.47;
  public canvasSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_slider_canvas_size'));
  public iconSize: number = ResUtils.getConvertNumber($r('app.float.Control_center_slider_icon_size'));
  // 图标距亮度条左边距
  public iconMargin: number = 10;
  public isExpand: boolean = false;
  public isHorizontal: boolean = true;
  public isSingleFoldStyle: boolean = false;
  public isLargeFoldStyle: boolean = false;
  public hasToggle: boolean = false;
  public moreSettingTopMargin: number = ResUtils.getConvertNumber(
    $r('app.float.Control_center_subpage_more_setting_top_margin'));

  // 是否展开态
  constructor(isExpand?: boolean, hasToggle: boolean = false) {
    this.hasToggle = hasToggle;
    if (!isExpand) {
      return;
    }
    this.isExpand = true;
    this.buttonWidth = ResUtils.getConvertNumber($r('app.float.Control_center_subpage_slider_button_width'));
    this.buttonHeight = ResUtils.getConvertNumber($r('app.float.Control_center_subpage_slider_button_height'));
    this.sliderWidth = ResUtils.getConvertNumber($r('app.float.Control_center_subpage_slider_width'));
    this.sliderHeight = ResUtils.getConvertNumber($r('app.float.Control_center_subpage_slider_height'));
    this.iconMargin = 13;
  }

  public updateVerticalStyle(): void {
    this.isHorizontal = false;
    this.buttonWidth = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_height'));
    this.buttonHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_width'));
    this.sliderWidth = ResUtils.getConvertNumber($r('app.float.Control_center_slider_height'));
    this.sliderHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_width'));
  }

  setSingleFoldSliderButtonViewData() {
    this.buttonWidth = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_slider_button_width'));
    this.buttonHeight = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_slider_button_height'));
    this.sliderWidth = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_slider_width'));
    this.sliderHeight = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_slider_height'));
    this.canvasSize = ResUtils.getConvertNumber($r('app.float.Single_fold_control_center_slider_icon_size'));
    this.isSingleFoldStyle = true;
  }

  setSingleExpandSliderButtonViewData() {
    if (this.isHorizontal) {
      this.buttonWidth = ResUtils.getConvertNumber($r('app.float.Single_expand_control_center_slider_button_width'));
      this.buttonHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_height'));
      this.sliderWidth = ResUtils.getConvertNumber($r('app.float.Single_expand_control_center_slider_width'));
      this.sliderHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_height'));
      this.canvasSize = ResUtils.getConvertNumber($r('app.float.Control_center_slider_canvas_size'));
    } else {
      this.buttonHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_height_vertical'));
      this.buttonWidth = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_height'));
      this.sliderHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_height_vertical'));
      this.sliderWidth = ResUtils.getConvertNumber($r('app.float.Control_center_slider_height'));
      this.canvasSize = ResUtils.getConvertNumber($r('app.float.Control_center_slider_canvas_size'));
    }
  }

  setLargeFoldSliderButtonViewData(isExpand?: boolean) {
    this.isLargeFoldStyle = true;
    if (isExpand) {
      this.subpageSliderScale = 1.06;
      return;
    }
    this.buttonWidth = ResUtils.getConvertNumber($r('app.float.Large_fold_control_center_slider_button_width'));
    this.buttonHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_button_height'));
    this.sliderWidth = ResUtils.getConvertNumber($r('app.float.Large_fold_control_center_slider_width'));
    this.sliderHeight = ResUtils.getConvertNumber($r('app.float.Control_center_slider_height'));
    this.canvasSize = ResUtils.getConvertNumber($r('app.float.Control_center_slider_canvas_size'));
  }
}

/**
 * 滑动条icon数据类
 */
export class SliderIconViewData {
  // lottie相关参数
  public lottieName: string = 'slider_lottie';
  public startFrameIndex: number = 61;
  public endFrameIndex: number = 300;
  public totalFrames: number = 360;
  public initialSegment: AnimationSegment | undefined = undefined;
  public mainCanvasRenderingContext: CanvasRenderingContext2D =
    new CanvasRenderingContext2D(new RenderingContextSettings(true));
  // 图片相关参数
  public iconName: Resource | string = '';
  public subPageIcon?: Resource;
  public iconTransitionEffect: boolean = true;

  constructor(lottieName?: string) {
    if (lottieName !== undefined) {
      this.lottieName = lottieName;
    }
  }
}

/**
 * 滑动条开关动效数据类
 */
@Observed
export class SliderButtonAnimViewData {
  @Track public shadowRadius: number = 0;
  @Track public uiValue: number = 0;
  @Track public sliderScale: ScaleOptions = { x: 1, y: 1 };
  @Track public buttonScale: ScaleOptions = { x: 1, y: 1 };
  @Track public iconScale: ScaleOptions = { x: 1, y: 1 };
  @Track public iconColor: ResourceColor = ColorModeViewModel.getInstance().getViewData().commonIconOffColor;
  @Track public iconOffset?: Position;
  @Track public showBlurLayer: boolean = false;
  @Track public sliderChosen: boolean = false;
  @Track public subpageHide: boolean = false;
  @Track public subpageOpacity: number = 0;
  @Track public subpageScale: ScaleOptions = { x: 0.8, y: 0.8 };
  @Track public isSliderButtonFocused: boolean = false;
  // 二级页进度条提亮数据
  @Track public sliderProgressBrightnessInternal: BrightnessOptions | undefined =
    ColorModeViewModel.getInstance().getViewData().brightnessNotChosenOption;
  // 二级页进度条颜色数据
  @Track public sliderProgressColor: ResourceColor =
    ColorModeViewModel.getInstance().getViewData().wifiBgOffColor;
  // 图标提亮数据
  @Track public iconBrightnessInternal: BrightnessOptions | undefined =
    ColorModeViewModel.getInstance().getViewData().foregroundPrimaryOptionOnBackground;
  @Track public symbolRendering: SymbolRenderingStrategy = SymbolRenderingStrategy.SINGLE;
  @Track public useLottieData: boolean = false;
  @Track public useSymbol: boolean = false;
  @Track public sliderIcon?: Resource;
}


/**
 * 滑动条共享数据用于判断当前是否拖动音量条和亮度条
 */
@Observed
export class SliderButtonShareData {
  public isDragging: boolean = false;

  public static getInstance(): SliderButtonShareData {
    return SingletonHelper.getInstance(SliderButtonShareData, 'SliderButtonShareData');
  }
}

/**
 * 二级页展开动效曲线类
 */
export class SubPageTransEffectData {
  // 主页开关转场效果曲线
  public buttonTransEffect: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.OPACITY,
      TransitionEffect.OPACITY.animation({
        duration: 20
      })
    );
  // 二级页边框展开收起动效曲线
  public subpageTransEffect: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.opacity(0.01).animation({
        duration: 83,
        curve: Curve.Friction
      }),
      TransitionEffect.opacity(0.01).animation({
        delay: 180,
        duration: 180,
        curve: curves.cubicBezierCurve(0.42, 0.00, 0.44, 1.00),
      }))
  // 二级页进度条和图标转场效果
  public brightnessTransEffect(scale: number): TransitionEffect {
    return TransitionEffect.scale({ x: scale, centerX: RTLUtil.isRTL() ? '100%' : 0 })
      .animation({ curve: curves.springMotion(0.34, 0.82) });
  }
  public brightnessElementTransEffect: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.OPACITY,
      TransitionEffect.OPACITY.animation({
        duration: 50
      })
    )
  public subpageBrightnessElementTransEffect: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        duration: 50,
      }),
      TransitionEffect.opacity(0.01).animation({
        delay: 180,
        duration: 180,
        curve: curves.cubicBezierCurve(0.42, 0.00, 0.44, 1.00),
      })
    )
  // 二级页进度背景转场效果
  public subpageBrightBackTransEffect: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        delay: 50,
        duration: 150,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
      }),
      TransitionEffect.OPACITY.animation({
        duration: 200,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
      })
    )
  // 二级页音频卡片转场效果
  public subpageElementTransEffect: TransitionEffect =
    TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({
        delay: 100,
        duration: 150,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      }).combine(
        TransitionEffect.scale({ x: 0.8, y: 0.8 }).animation({
          curve: curves.springMotion(0.34, 0.68)
        })),

      TransitionEffect.OPACITY.animation({
        duration: 100,
        curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      }).combine(
        TransitionEffect.scale({
          x: 0.8,
          y: 0.8,
        }).animation({
          curve: curves.springMotion(0.34, 0.68)
        })),
    );
}
