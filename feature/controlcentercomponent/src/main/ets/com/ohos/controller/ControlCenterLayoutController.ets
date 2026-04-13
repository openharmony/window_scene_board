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

import { HashMap } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy { SCBScreenProperty } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { RotationConstants } from '@ohos/commonconstants';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';
import { ScreenSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenSessionAdapter';
import { ViewManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ViewManagerAdapter';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import {
  LINEAR_GRADIENT_PROPORTION_HEADER,
  HEAD_SPACE_DIFF,
  NORMAL_PORTRAIT_CONTENT_START_OFFSET_COMPACT
} from '../common/Constants';
import lazy { MultiWindowToggleController } from './MultiWindowToggleController'

const TAG = 'Ctrl.LayoutController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const UPDATE_SCREEN_CHANGE_DELAY: number = 50;

/**
 * 控制中心布局
 */
export interface ControlCenterLayoutConfig {
  // 面板宽度
  panelWidth: number | string;

  // 面板内容对齐
  panelAlignment: Alignment;

  // 面板边距
  panelMargin?: Margin | Length;

  // 头部区域margin
  headerMargin: Margin | Length;

  // 头部高度
  headerHeight: number;

  // 头部宽度
  headerWidth?: number;

  // 亮度条高度
  brightnessHeight: number;

  // 亮度条canvas顶部margin
  brightnessCanvasMarginTop?: Length;

  // 亮度条小太阳图标margin
  brightnessSunIconMargin: Margin;

  // 快捷开关列数
  toggleColumns: number;

  // 快捷开关下方是否显示亮度条
  showBrightnessUnderToggles: boolean;

  // 快捷开关上方是否展示播控
  showMediaAboveCardToggles: boolean;

  // 二级页面是否垂直居中
  subpageVerticalCenter: boolean;

  // 二级页面margin
  subpageMargin?: Margin | Length;

  // 二级页面高度
  subpageHeight?: number | string;

  // 是否显示头部区域
  isShowHeaderLayout: boolean;

  // 单列卡片宽度
  singleCardWidth?: number | string;

  // 播控卡片与快捷按钮的布局方向
  flexDirection: FlexDirection;

  // 主布局主轴对齐方式
  flexJustifyContent: FlexAlign;

  // 主布局纵轴对齐方式
  flexAlignItems: ItemAlign;

  // 编辑时是否锁定屏幕方向
  lockRotationWhenEdit?: boolean;

  // 编辑页是否展示两列
  isEditPageDoubleColumn?: boolean;

  // 编辑页两列间隔
  editPageDoubleColumnGap?: number;

  // 编辑页padding
  editPagePadding?: Padding;

  // 折叠展开横屏头部padding
  foldEditHeadOffset?: Position;

  // 主页面板宽度
  mainPanelWidth: number | string;

  // 主页面板边距
  mainPanelMargin?: Margin | Length;

  // 滚动条宽度
  scrollWidth: number | string;

  // 滚动条内边距
  scrollPadding?: Padding;

  // 列表初始起始位置
  contentStartOffset?: number;

  // 列表初始结束位置
  contentEndOffset?: number;

  // 头部模糊区域宽度
  headBlurAreaWidth?: number;
}

export const CC_LAYOUT_CONFIGS: ControlCenterLayoutConfig[] = [
// 直板机竖屏，折叠屏外屏竖屏
  {
    panelWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    panelAlignment: Alignment.Top,
    headerHeight: ResUtils.getNumber($r('app.float.control_center_header_height')),
    headerWidth:  ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    brightnessHeight: ResUtils.getNumber($r('app.float.Control_center_brightness_height')),
    brightnessSunIconMargin: {
      left: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_top_margin')),
      top: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_left_margin')),
    },
    toggleColumns: ResUtils.getNumber($r('app.float.quick_toggle_column')),
    showBrightnessUnderToggles: true,
    subpageVerticalCenter: true,
    headerMargin: {
      top: ResUtils.getNumber($r('app.float.Control_center_header_top_margin')) -
        (0),
      bottom: ResUtils.getNumber($r('app.float.Control_center_mediaAndWifiBlue_top_margin')),
    },
    isShowHeaderLayout: true,
    showMediaAboveCardToggles: true,
    singleCardWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    flexDirection: FlexDirection.Column,
    flexJustifyContent: FlexAlign.Start,
    flexAlignItems: ItemAlign.Center,
    lockRotationWhenEdit: true,
    // 304 * 1.05 = 320,304为亮度条长度,1.05为亮度条滑动时放大的倍数，为了避免亮度条滑动时被截断，所以调整宽度为320
    mainPanelWidth: 320,
    scrollWidth: 320,
    contentStartOffset: 132,
    contentEndOffset: 320,
    subpageHeight: 398,
  },
  // 直板机横屏，折叠屏外屏横屏
  {
    panelWidth: 640,
    panelAlignment: Alignment.Top,
    headerHeight: 0,
    brightnessHeight: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_height_landscape')),
    brightnessCanvasMarginTop: 4,
    brightnessSunIconMargin: {
      left: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_left_margin_landscape')),
      top: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_left_margin_landscape')),
    },
    toggleColumns: ResUtils.getNumber($r('app.float.quick_toggle_column')),
    showBrightnessUnderToggles: false,
    subpageVerticalCenter: true,
    headerMargin: {
      top: ResUtils.getNumber($r('app.float.Control_center_landscape_header_top_margin')),
      bottom: ResUtils.getNumber($r('app.float.Control_center_mediaAndWifiBlue_landscape_top_margin')),
    },
    isShowHeaderLayout: false,
    showMediaAboveCardToggles: false,
    singleCardWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    flexDirection: FlexDirection.Row,
    flexJustifyContent: FlexAlign.Center,
    flexAlignItems: ItemAlign.Start,
    mainPanelWidth: 640,
    scrollWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    contentEndOffset: 0,
    subpageMargin: {top: 36, bottom: 39}
  },
  // 折叠屏内屏：左侧播控中心，右侧控制中心，横屏布局基于竖屏布局计算结果居中显示
  {
    panelWidth: ResUtils.getNumber($r('app.float.Large_fold_control_center_portrait_width')),
    panelAlignment: Alignment.TopEnd,
    panelMargin: { right: 36 },
    editPagePadding: { left: 20, right: 20 },
    foldEditHeadOffset:{ x: 20, y: 0 },
    headerHeight: ResUtils.getNumber($r('app.float.control_center_header_height')),
    headerWidth:  ResUtils.getNumber($r('app.float.Large_fold_control_center_portrait_width')),
    brightnessHeight: ResUtils.getNumber($r('app.float.Control_center_brightness_height')),
    brightnessSunIconMargin: {
      left: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_top_margin')),
      top: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_left_margin')),
    },
    toggleColumns: ResUtils.getNumber($r('app.float.quick_toggle_column')),
    showBrightnessUnderToggles: true,
    subpageVerticalCenter: true,
    headerMargin: {
      top: ResUtils.getNumber($r('app.float.Control_center_header_top_margin')),
      bottom: ResUtils.getNumber($r('app.float.Control_center_mediaAndWifiBlue_top_margin')),
    },
    isShowHeaderLayout: true,
    showMediaAboveCardToggles: false,
    singleCardWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    flexDirection: FlexDirection.Column,
    flexJustifyContent: FlexAlign.Start,
    flexAlignItems: ItemAlign.Center,
    isEditPageDoubleColumn: true,
    lockRotationWhenEdit: true,
    mainPanelWidth: ResUtils.getNumber($r('app.float.Large_fold_control_center_portrait_width')),
    scrollWidth: ResUtils.getNumber($r('app.float.Large_fold_control_center_portrait_width')),
    mainPanelMargin: { right: 36 },
    subpageHeight: 398,
    contentStartOffset: 132,
    contentEndOffset: 320
  },
  // 平板：右上角显示，不区分横竖屏
  {
    panelWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    panelAlignment: Alignment.TopEnd,
    panelMargin: { top: ResUtils.getNumber($r('app.float.status_bar_phone_height')), right: 36 },
    editPagePadding: { left: 20, right: 20 },
    foldEditHeadOffset:{ x: 20, y: 0},
    headerHeight: ResUtils.getNumber($r('app.float.control_center_header_height')),
    brightnessHeight: ResUtils.getConvertNumber($r('app.float.Control_center_brightness_height')),
    brightnessSunIconMargin: {
      left: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_top_margin')),
      top: ResUtils.getNumber($r('app.float.Control_center_brightness_icon_left_margin')),
    },
    toggleColumns: ResUtils.getNumber($r('app.float.quick_toggle_column')),
    showBrightnessUnderToggles: true,
    subpageVerticalCenter: false,
    headerMargin: {
      top: ResUtils.getNumber($r('app.float.Control_center_header_top_margin')),
      bottom: ResUtils.getNumber($r('app.float.Control_center_mediaAndWifiBlue_top_margin')),
    },
    isShowHeaderLayout: true,
    showMediaAboveCardToggles: true,
    singleCardWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    flexDirection: FlexDirection.Column,
    flexJustifyContent: FlexAlign.Start,
    flexAlignItems: ItemAlign.Center,
    isEditPageDoubleColumn: true,
    editPageDoubleColumnGap: 24,
    mainPanelWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    scrollWidth: ResUtils.getNumber($r('app.float.Control_center_portrait_width')),
    mainPanelMargin: { right: 36 },
    subpageHeight: 398,
    contentStartOffset: 132,
    contentEndOffset: 320,
    // (mainPanelWidth + mainPanelMargin.right + 20) / LINEAR_GRADIENT_PROPORTION
    headBlurAreaWidth: 450
  },
];

// 控制中心布局索引
export enum ControlCenterLayoutIndex {
  // 直板机竖屏，折叠屏外屏竖屏
  NORMAL_PORTRAIT = 0,
  // 直板机横屏，折叠屏外屏横屏
  NORMAL_LANDSCAPE = 1,
  // 折叠屏内屏：左侧播控中心，右侧控制中心，不区分横竖屏
  FOLD_EXPANDED = 2,
  // 平板：右上角显示，不区分横竖屏
  PAD = 3,
}

type LayoutChangeCallback = (index: ControlCenterLayoutIndex, screenProp?: SCBScreenProperty) => void;

export class ControlCenterLayoutController {
  private static sControlCenterLayoutController?: ControlCenterLayoutController;
  private currentIndex: ControlCenterLayoutIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
  private callbackMap: HashMap<string, LayoutChangeCallback> = new HashMap();
  /**
   * 屏幕状态变化延迟刷新控制中心布局timeId
   */
  private screenPropertyChangeTimeId: number = -1;

  constructor() {
    log.showInfo('initLayout, %{public}d', DropDownAdapter.getDropDownId());
    this.initLayout();
    log.showInfo(`init layout is ${this.currentIndex}`);
  }

  public static getInstance(): ControlCenterLayoutController {
    if (!ControlCenterLayoutController.sControlCenterLayoutController) {
      ControlCenterLayoutController.sControlCenterLayoutController = new ControlCenterLayoutController();
    }
    return ControlCenterLayoutController.sControlCenterLayoutController;
  }

  /**
   * 获取当前布局索引
   * @returns 当前布局索引
   */
  public getCurrentIndex(): ControlCenterLayoutIndex {
    return this.currentIndex;
  }

  /**
   * 设置控制中心布局改变回调
   * @param callback 控制中心布局改变回调
   */
  public setLayoutChangeCallback(callbackTag: string, callback?: LayoutChangeCallback): void {
    if (callback === undefined) {
      this.callbackMap.remove(callbackTag);
    } else {
      this.callbackMap.set(callbackTag, callback);
      callback(this.currentIndex, ScreenSessionAdapter.getSCBScreenProperty());
    }
  }

  private initLayout(): void {
    if (DeviceHelper.isPad()) {
      this.currentIndex = ControlCenterLayoutIndex.PAD;
      return;
    }

    if (ScreenSessionAdapter.isFoldablePhoneExpandStatusSync()) {
      this.currentIndex = ControlCenterLayoutIndex.FOLD_EXPANDED;
    }
    ScreenSessionAdapter
      .registerScreenPropertyChangeCallbacks(
        {
          callback: this.updateLayoutIndex,
          screenId: undefined,
          isRotatable: true,
          persistentId: DropDownAdapter.getDropDownId()
        }, `${TAG}_registerScreenPropertyChangeCallbacks`);
    this.setSingleExpendLayout(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
  }

  private setSingleExpendLayout(layoutIndex: ControlCenterLayoutIndex): void {
    if (CheckEmptyUtils.isEmpty(CC_LAYOUT_CONFIGS[layoutIndex])) {
      return;
    }
  }

  private updateLayoutIndex = async (property: SCBScreenProperty): Promise<void> => {
    let newIndex: number = this.currentIndex;
    let configUpdated: boolean = false;
    if (await ScreenSessionAdapter.isFoldablePhoneExpandStatus()) {
      newIndex = ControlCenterLayoutIndex.FOLD_EXPANDED;
      configUpdated = true;
      let extraMargin: number = 0;
      if (property.width > property.height &&
        !await ScreenSessionAdapter.isSecondaryFoldablePhoneExpandStatus()) {
        extraMargin = px2vp(property.width - property.height) / 2;
      }
      CC_LAYOUT_CONFIGS[newIndex].editPagePadding = { left: 20 + extraMargin, right: 20 + extraMargin };
      CC_LAYOUT_CONFIGS[newIndex].foldEditHeadOffset = { x: 20 + extraMargin, y: 0 };
      CC_LAYOUT_CONFIGS[newIndex].panelMargin = { right: 36 + extraMargin };
      CC_LAYOUT_CONFIGS[newIndex].mainPanelMargin = { right: 36 + extraMargin };
    } else {
      if (property.rotation === RotationConstants.ROTATION_90 || property.rotation === RotationConstants.ROTATION_270) {
        newIndex = ControlCenterLayoutIndex.NORMAL_LANDSCAPE;
      } else {
        newIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
        this.setSingleExpendLayout(newIndex);
      }
    }

    if (this.currentIndex === newIndex && !configUpdated) {
      return;
    }

    log.showInfo(`on cc layout change: ${this.currentIndex} => ${newIndex}`);
    this.currentIndex = newIndex;
    if (this.screenPropertyChangeTimeId !== -1) {
      clearTimeout(this.screenPropertyChangeTimeId);
      this.screenPropertyChangeTimeId = -1;
    }
    let delayUpdateTime: number = DropDownPanelManager.isPanelShowing() ? 0 : UPDATE_SCREEN_CHANGE_DELAY;
    this.screenPropertyChangeTimeId = setTimeout(() => {
      this.callbackMap.forEach((callback) => {
        callback?.(this.currentIndex, property);
      });
      this.screenPropertyChangeTimeId = -1;
    }, delayUpdateTime);
  }
}
