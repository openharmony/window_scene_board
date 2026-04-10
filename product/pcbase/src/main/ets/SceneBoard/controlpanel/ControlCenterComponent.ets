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

import {
  DeviceHelper,
  EvtBus,
  PluginPosition,
  PluginSlot,
  sEventManager,
  TargetPanel,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import {
  ResUtils,
  SCBScreenProperty,
  SCBPropertyChangeReason,
  SCBScreenSessionManager,
  windowMgr
} from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import {
  AppStorageUtil, DataProperty, LogHelper,
  LogDomain,
} from '@ohos/basicutils';
import {
  ContentItemOption,
  ControlCenterData,
  ControlCenterItem
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, {
  ControlCenterComponentStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import Controller from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import { SubPageLayout } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/pages/SubPageLayout';
import {
  ControlListController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlListController';
import {
  AnimationDataArray,
  ControlCenterAnimationData
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/ControlCenterAnimationData';
import { PrivacySensorViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/PrivacySensorViewData';
import {
  ControlCenterLayoutIndex
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterLayoutController';
import { ToggleStyle } from '@ohos/systemuicommon';
import { ControlCenterHomeViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/vm/ControlCenterHomeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import MediaCardLayout from './ControlCenterMediaCardLayout';
import QuickToggleLayout from './ControlCenterQuickToggleLayout';
import HeaderLayout, { HeaderButtonType } from './ControlCenterHeaderLayout';
import PrivacySensor from './PrivacySensor';

const TAG = 'Ctrl.ControlCenterLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const SUB_PANEL_ANIM_DURATION: number = 400;
const TOGGLE_EDIT_ANIM_DURATION: number = 500;
const DEFAULT_ANIM_DURATION: number = 300;
const PRIVACY_SENSOR_WIDTH: number = 360;

const INDEX_HEADER: number = 0;
const INDEX_MEDIA: number = 1;
const INDEX_TOGGLE: number = 2;
const INDEX_PRIVACY: number = 3;

/**
 * 控制中心根布局
 */
@Component
export default struct ControlCenterComponent {
  @State data: ControlCenterData = Controller.getData();
  @State style: ControlCenterComponentStyle = StyleConfiguration.getControlCenterComponentStyle();
  private buttonType: HeaderButtonType = HeaderButtonType.NOTHING;
  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;
  @State contentDataList: ContentItemOption[] = Array.from(Controller.getContent().values());
  contentDataKeys: number[] = [ControlCenterItem.ITEM_MEDIA, ControlCenterItem.ITEM_TOGGLE, ControlCenterItem.ITEM_IOT];
  @State translateYArr: number[] = [];
  @State opacityList: number[] = Array.from(Controller.getContent().keys())
  scroller: Scroller = new Scroller();
  @State listHeight: number = 0;
  @State contentHeight: number = 0;
  @State bankHeight: number = 0;
  translateY: number = 0;
  transYCoefficient: number = 2 / 3;
  @State headerOpacity: number = 0;
  @State scaleArr: number[] = [];
  @State borderRadiusArr: Array<number> = [];
  @State ntfItemRotateAngels: Array<number> = [];
  @State itemTranslateY: Array<number> = [];
  @State listRadiusTop: number = this.style.borderRadius;
  @State listRadiusBottom: number = this.style.borderRadius;
  @State isToggleShow: boolean = true;
  listController: ControlListController = new ControlListController();
  headerHeight: number = 0;
  mediaHeight: number = 0;
  privacyHeight: number = 0;
  @State toggleHeight: number = 0;
  lastIndex: number = 0;
  firstIndex: number = 0;
  topItemHeight: number = 0;
  @State listPosY: number = 0;
  componentHeightArray: Array<number> = [];
  lastPanelType: TargetPanel = TargetPanel.NONE;
  @State isVertical: boolean = true;
  @State borderPadding: number = StyleConfiguration.getControlCenterComponentStyle().panelPadding;
  @StorageLink('DropDownControlWidth') controlWidth: number = 0;
  @StorageLink('DropDownControlHeight') controlHeight: number = 0;
  @State controlCenterArea: number = 0;
  /**
   * Number of control center Height
   */
  @State controlCenterQuickHeight: number = 0;
  @Provide ccLayoutIndex: ControlCenterLayoutIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
  @State animationDataArray: AnimationDataArray = new AnimationDataArray();
  @StorageLink('currentDragSlotItem') currentDragSlotItem: string = '';
  private isHad: boolean = DeviceHelper.isHAD();
  @Provide privacySensorData: PrivacySensorViewData = new PrivacySensorViewData();
  @StorageLink('isBusinessStyle') isBusinessStyle: boolean = true;
  @State viewData: ControlCenterHomeViewData = new ControlCenterHomeViewData();
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  aboutToAppear() {
    ToggleStyle.getToggleLabelStyle().setLabelColor(this.colorModeViewData.wifiOffTextColor);
    // 注册监听
    Controller.registerListener();
    // 控制中心状态监听
    sEventManager.subscribe('ControlCenterState', (state: ControlCenterState) => {
      this.onControlCenterStateChanged(state);
    });
    this.onControlCenterStateChanged(ControlCenterState.MAIN_LAYOUT);

    log.showInfo(TAG, 'aboutToAppear. state: ' + this.data.state);
    AppStorageUtil.setOrCreate('isMarkingRenderGroupOfControl', true, new DataProperty(true, false));

    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks((screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
        this.isVertical = screenProperty.rotation === RotationConstants.ROTATION_0 ||
          screenProperty.rotation === RotationConstants.ROTATION_180 ||
          screenProperty.rotation === RotationConstants.ROTATION_360;
        if (!this.isVertical) {
          let disWidth = screenProperty.width;
          let landWidth = ResUtils.getLandGridRowWidth(disWidth);
          let margin = (disWidth - landWidth) / 2;
          let marginStr = px2vp(margin);
          this.borderPadding = marginStr;
        } else {
          this.borderPadding = this.style.panelPadding;
        }
      });
    for (let i = 0; i < 9; i++) {
      this.animationDataArray.push(new ControlCenterAnimationData(1, 1, 0, 0));
    }
  }

  aboutToDisappear() {
    // 反注册监听
    Controller.unregisterListener();
    log.showInfo(TAG, 'aboutToDisappear.');
  }

  /**
   * 隐私指示器
   */
  @Builder
  loadPrivacySensor() {
    PrivacySensor()
      .visibility(this.privacySensorData.isApplicationInterview ? Visibility.Visible : Visibility.None)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        this.privacyHeight = Number(newValue.height);
        this.componentHeightArray[INDEX_PRIVACY] = this.privacyHeight;
        this.onComponentHeightChanged()
      })
  }

  build() {
      // 主界面
    this.loadMainLayout();
  }

  /**`
   * 加载主界面布局
   */
  @Builder
  loadMainLayout() {
    Column() {
      // 隐私指示器
      Row() {
        this.loadPrivacySensor()
      }
      .justifyContent(FlexAlign.Center)
      .width(PRIVACY_SENSOR_WIDTH)
      .zIndex(1)

      // 控制中心头部区域
      HeaderLayout({ buttonType: this.buttonType, isVertical: this.isVertical })
        .opacity(1)// Adapts to bottom-layer gesture event determination specifications.
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.headerHeight = Number(newValue.height);
          if (this.headerHeight > 0) {
            this.componentHeightArray[INDEX_HEADER] = this.headerHeight;
            this.onComponentHeightChanged();
          }
        })

      Column() {
        ForEach(this.contentDataKeys, (item: number, index?: number) => {
          Column() {
            if (item === ControlCenterItem.ITEM_MEDIA) {
              // 媒体卡片及WIFI蓝牙卡片
              MediaCardLayout({ listPosY: this.listPosY, data: $data })
                .onAreaChange((oldValue: Area, newValue: Area) => {
                  this.mediaHeight = Number(newValue.height);
                  if (this.mediaHeight > 0) {
                    this.componentHeightArray[INDEX_MEDIA] = this.mediaHeight;
                    this.onComponentHeightChanged();
                  }
                })
            } else if (item === ControlCenterItem.ITEM_TOGGLE) {
              // 快捷开关
              QuickToggleLayout({
                animationDataArray: $animationDataArray,
                listController: this.listController,
                controlCenterArea: $controlCenterArea,
                controlCenterQuickHeight: $controlCenterQuickHeight,
                isShowDivider: true,
                isHideQuickToggle: false
              })
                .visibility(this.isToggleShow ? Visibility.Visible : Visibility.Hidden)
                .onAreaChange((oldValue: Area, newValue: Area) => {
                  // 更新list高度
                  this.toggleHeight = Number(newValue.height);
                  this.onListHeightChanged();
                  if (this.toggleHeight > 0) {
                    this.componentHeightArray[INDEX_TOGGLE] = this.toggleHeight;
                    this.onComponentHeightChanged();
                  }
                })
                .borderRadius(this.borderRadiusArr[index as number])
            }
          }
          .clip(false)
        })
      }
      .clip(false)
      .width('100%')
      .height(this.listHeight)
      .borderRadius({
        topLeft: this.listRadiusTop,
        topRight: this.firstIndex === 0 ? 0 : this.listRadiusTop,
        bottomLeft: this.listRadiusBottom,
        bottomRight: this.listRadiusBottom
      })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .visibility(this.data.state === ControlCenterState.MAIN_LAYOUT ? Visibility.Visible : Visibility.Hidden)
    .zIndex(0)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.controlWidth = Number(newValue.width) - (this.borderPadding * 2);
      this.controlHeight = Number(newValue.height);
      log.showInfo(TAG, `onAreaChange, oldValue: ${JSON.stringify(oldValue)} newValue: ${JSON.stringify(newValue)} \
      borderPadding: ${this.borderPadding} controlWidth: ${this.controlWidth}`);
      // 更新容器高度
      this.contentHeight = Number(newValue.height);
      this.onListHeightChanged();
    })
  }

  /**
   * 加载二级界面布局
   */
  @Builder
  loadSubPanelLayout() {
    if (sToggleSubWindowController.getCurrentSubPanelSlot()) {
      SubPageLayout().zIndex(1)
    }
  }

  /**
   * 控制中心状态切换回调
   *
   * @param state 新状态值
   */
  onControlCenterStateChanged(state: ControlCenterState): void {
    if (this.data.state === state) {
      log.showInfo(TAG, `onControlCenterStateChanged, new state:${state}, same with last.`);
      return;
    }
    let isSubPage: boolean =
      (this.data.state === ControlCenterState.SUB_PANEL && state === ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state === ControlCenterState.MAIN_LAYOUT && state === ControlCenterState.SUB_PANEL);
    let isToggleEdit: boolean =
      (this.data.state === ControlCenterState.MAIN_LAYOUT && state === ControlCenterState.TOGGLE_EDIT) ||
        (this.data.state === ControlCenterState.TOGGLE_EDIT && state === ControlCenterState.MAIN_LAYOUT);
    let needAnim = isSubPage || isToggleEdit;
    // 进入退出编辑界面动画参数
    log.showInfo(TAG, `onControlCenterStateChanged, needAnim:${needAnim}, new state:${state}, old state:${this.data.state}`)
    let duration = needAnim ?
      (isSubPage ? SUB_PANEL_ANIM_DURATION : TOGGLE_EDIT_ANIM_DURATION) : DEFAULT_ANIM_DURATION;
    this.isToggleShow = state != ControlCenterState.TOGGLE_EDIT;
    if (!needAnim) {
      this.data.state = state;
      return;
    }

    animateTo({
      duration: duration,
      tempo: 1.0,
      curve: Curve.Friction,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        log.showInfo(TAG, `onDataChange, show anim finish.`)
      }
    }, () => {
      this.data.state = state;
      log.showInfo(TAG, `onDataChange, animateTo`);
    });
  }

  /**
   * 横竖屏切换回调
   */
  onOrientationChanged() {
    this.bankHeight = 0;
  }

  /**
   * 获取容器和list高度, 计算差值给BankItem, 使List高度超过一屏
   */
  onListHeightChanged() {
    if (this.isLandscape) {
      this.listHeight = this.contentHeight - this.headerHeight - this.style.bottomSpaceLand;
    } else {
      this.listHeight = this.contentHeight - this.headerHeight - this.style.marginBottom;
    }
    log.showInfo(`onListHeightChanged, contentHeight: ${this.contentHeight}, listHeight: ${this.listHeight}, bankHeight: ${this.bankHeight}, headerHeight: ${this.headerHeight}, mediaHeight: ${this.mediaHeight}, toggleHeight: ${this.toggleHeight}`);
  }

  onComponentHeightChanged(): void {
    if (this.componentHeightArray.length <= INDEX_TOGGLE) {
      return;
    }
    let windowName = PluginSlot.SLOT_STATUS_CONTROL_CENTER;
    let initRect = windowMgr.getWindowPosition(windowName);
    if (initRect === null) {
      return;
    }
    let totalHeight = 0;
    this.componentHeightArray.forEach((height: number) => {
      log.showInfo(`height: ${height}`)
      totalHeight += height;
    })
    log.showInfo(`totalHeight: ${totalHeight}`)
    // 组件高度+组件间距+底部padding
    totalHeight = vp2px(totalHeight);
    if (totalHeight === initRect.height) {
      return;
    }
    initRect.height = totalHeight;
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: windowName,
      position: PluginPosition.POSITION_NONE,
      area: initRect
    });
  }
}
