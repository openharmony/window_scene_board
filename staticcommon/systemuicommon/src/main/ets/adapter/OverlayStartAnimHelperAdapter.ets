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

import curves from '@ohos.curves';
import { ExtAppConstants } from '@ohos/commonconstants';
import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import lazy { OverlayAnimScene } from '../overlay/OverlayCardInfo';
import lazy { OverlayStartAnimHelper } from '../overlay/OverlayStartAnimHelper';
import lazy { DefaultPanelZIndex } from '../base/common/info/DefaultPanelZIndex';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';

const TAG = 'OverlayStartAnimHelperAdapter'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export const ICON_ID_SETTINGS = 'Ctrl.HeaderLayout_Image_settings';
export const COMPONENT_ID_SETTINGS = 'Ctrl.HeaderLayout_Bg_settings';

// copy from controlcentercomponent/src/main/ets/com/ohos/model/StartAbilityOverlayAnimateData.ets::StartAbilityOverlayAnimateConstants
export class StartAbilityOverlayAnimateConstants {
  // mainLayout param
  public static readonly MAIN_LAYOUT_SCALE: number = 0.88; // 控制中心面板缩放变化终点参数
  public static readonly MAIN_LAYOUT_OPACITY: number = 0.2; // 控制中心透明度变化终点参数
  public static readonly MAIN_LAYOUT_ANIM_TIME: number = 167; // 控制中心淡出动效时长
  public static readonly MAIN_LAYOUT_STAY_TIME: number = 600; // 控制中心停留下拉状态时长

  // app window param
  public static readonly APP_WINDOW_OPACITY_TIME: number = 166; // 透明度变化动效时长
  public static readonly APP_WINDOW_CURVE: ICurve = curves.interpolatingSpring(0, 1, 439, 48); // 应用窗口展开动画曲线
  public static readonly APP_WINDOW_BORDER_RADIUS_TIME: number = 166; // 圆角变化动效时长
  public static readonly APP_WINDOW_MASK_COLOR: ResourceColor = '#66000000'; // 应用窗口上方蒙层颜色
  public static readonly APP_WINDOW_MASK_STAY_TIME: number = 166; // 应用窗口上方蒙层停留持续时长

  // icon param
  public static readonly ICON_OPACITY_TIME: number = 83; // icon透明度变化动效时长
  public static readonly ICON_BORDER_RADIUS: number = 20; // icon圆角初始值
}

/**
 * 卡片信息
 */
interface CardInfo {
  left: number;
  top: number;
  width?: number;
  height?: number
}

interface IOverlayCardCallback {
  /**
   * 卡片位置信息, 若指定则以该位置为准
   */
  cardPosition?: CardInfo;

  /**
   * 卡片内容资源
   */
  cardResource?: Resource;

  /**
   * 卡片内容位置
   */
  cardContentPosition?: CardInfo;

  /**
   * 动效启动回调
   */
  onAnimActive?: () => void;

  /**
   * 动效结束回调
   */
  onAnimInactive?: () => void;

  /**
   * 动效取消回调
   */
  onAnimCanceled?: () => void;
}

export class OverlayStartAnimHelperAdapter {
  /**
   * overlay卡片启动前，动效准备
   *
   * @param card 卡片数据
   */
  @threadCall(ThreadCallType.RegisterOnce)
  public static startAnimPre(cardCallback: IOverlayCardCallback, tag: string): void {
    log.showInfo(`startAnimPre ${tag}`);
    OverlayStartAnimHelper.startAnimPre({
      animScene: OverlayAnimScene.TYPE_START_APP_FROM_ICON,
      cardBgId: COMPONENT_ID_SETTINGS,
      cardContentId: ICON_ID_SETTINGS,
      startBundleName: ExtAppConstants.PKG_SETTINGS,
      oriPanelZIndex: DefaultPanelZIndex.PANEL_DROPDOWN,
      cardBgColor: StartAbilityOverlayAnimateConstants.APP_WINDOW_MASK_COLOR,
      cardRadius: {
        topLeft: StartAbilityOverlayAnimateConstants.ICON_BORDER_RADIUS,
        topRight: StartAbilityOverlayAnimateConstants.ICON_BORDER_RADIUS,
        bottomLeft: StartAbilityOverlayAnimateConstants.ICON_BORDER_RADIUS,
        bottomRight: StartAbilityOverlayAnimateConstants.ICON_BORDER_RADIUS
      },
      sceneSizeAndPositionAnimParam: {
        curve: StartAbilityOverlayAnimateConstants.APP_WINDOW_CURVE,
      },
      sceneBorderRadiusAnimParam: {
        curve: Curve.Friction,
        duration: StartAbilityOverlayAnimateConstants.APP_WINDOW_BORDER_RADIUS_TIME
      },
      sceneMaskColorAnimParam: {
        curve: Curve.Friction,
        duration: StartAbilityOverlayAnimateConstants.APP_WINDOW_MASK_STAY_TIME
      },
      sceneAlphaAnimParam: {
        curve: Curve.Friction,
        duration: StartAbilityOverlayAnimateConstants.APP_WINDOW_OPACITY_TIME
      },
      iconAlphaAnimParam: {
        curve: Curve.Friction,
        duration: StartAbilityOverlayAnimateConstants.ICON_OPACITY_TIME
      },
      cardResource: cardCallback?.cardResource,
      cardPosition: new RectInfo(
        cardCallback?.cardPosition?.left,
        cardCallback?.cardPosition?.top,
        cardCallback?.cardPosition?.width,
        cardCallback?.cardPosition?.height),
      cardContentPosition: new RectInfo(
        cardCallback?.cardContentPosition?.left,
        cardCallback?.cardContentPosition?.top,
        cardCallback?.cardContentPosition?.width,
        cardCallback?.cardContentPosition?.height),
      onAnimActive: cardCallback.onAnimActive,
      onAnimCanceled: cardCallback.onAnimCanceled,
      onAnimInactive: cardCallback.onAnimInactive
    });
  }

  /**
   * 重置动效控制器
   */
  @threadCall()
  public static resetOverlayTransition(reason?: string): void {
    log.showWarn(`resetOverlayTransition ${reason}`);
    OverlayStartAnimHelper.resetOverlayTransition(reason);
  }
}