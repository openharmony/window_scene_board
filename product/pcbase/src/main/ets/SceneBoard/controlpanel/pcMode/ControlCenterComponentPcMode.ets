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

import {
  PluginSlot,
  sEventManager,
  EvtBus,
  PluginPosition,
  WindowPositionChangeEvent,
  obtainLocalEvent,
  PluginInfo,
  PluginParseInfo,
} from '@ohos/frameworkwrapper';
import { ResUtils, windowMgr } from '@ohos/windowscene';
import { FASlotName } from '@ohos/commonconstants';
import {
  LogHelper,
  LogDomain, AppStorageUtil, DataProperty,
} from '@ohos/basicutils';
import {
  ControlCenterData
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, { ControlCenterQuickToggleLayoutStyle } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import Controller from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import HeaderLayout, { HeaderButtonType } from '../ControlCenterHeaderLayout';
import { PrivacySensorViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/PrivacySensorViewData';
import {ControlCenterAnimationData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/ControlCenterAnimationData';
import {ControlCenterLayoutIndex } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterLayoutController';
import { ToggleData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/Constants';
import { QuickToggleController } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';
import { ControlCenterHomeViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/vm/ControlCenterHomeViewData';
import PrivacySensor from '../PrivacySensor';
import { StatusBarType } from '@ohos/systemuicommon';
import MediaCardLayout from '../ControlCenterMediaCardLayout';
import Volume from '../volumeslider/pages/Volume';
import Brightness from '@ohos/controlcentercomponent/src/main/ets/com/ohos/pages/newStyle/Brightness';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { PCToggleFactory } from '../pcStyle/PCStyleFactory';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { LengthMetrics } from '@kit.ArkUI';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import MediaPlaybackComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaPlaybackComponent';
import Prompt from '@ohos.promptAction';
import Constants from '../common/constants';
import { ModeChangeController } from '../../modechangemanager/ModeChangeController'

const TAG = 'Ctrl.ControlCenterLayoutPcMode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const PRIVACY_SENSOR_WIDTH: number = 360;
const INDEX_HEADER: number = 0;
const INDEX_PRIVACY: number = 1;
const INDEX_MEDIA: number = 2;
const INDEX_BRIGHTNESS: number = 3;
const INDEX_VOLUME: number = 4;
const INDEX_QUICK_TOGGLE: number = 5;

const TOP_TOGGLE_ROW_ITEM_NAME: string = 'topToggleRow';
const ADD_MORE_TOP_BUTTON_NAME: string = 'addMoreTopButton';
const TOGGLE_ROW_ITEM_NAME: string = 'quickToggleRow';
const TOTAL_HEIGHT_PADDING = 54;
const TOP_TOGGLE_MAX = 4;
const MEDIA_CARD_MARGIN_TOP = -200;

/**
 * 控制中心根布局
 */
@Component
export default struct ControlCenterComponentPcMode {
  @StorageLink('isBusinessStyle') isBusinessStyle: boolean = true;
  @State data: ControlCenterData = Controller.getData();
  @State opacityList: number[] = Array.from(Controller.getContent().keys());
  @State isVertical: boolean = true;
  @State @Watch('handleToggleDataChanged') toggleData: ToggleData = QuickToggleController.getInstance().getToggleData();
  @State quickToggles: string[] = [];
  @State topToggleArray: string[][] = [];
  @State animationData: ControlCenterAnimationData = new ControlCenterAnimationData(1, 1, 0, 0);
  @State viewData: ControlCenterHomeViewData = new ControlCenterHomeViewData();
  /**
   * 控制中心ListItem索引集合
   */
  @State contentIndexArr : string[] = [];
  @State controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @State subpageHeight: number = 300;
  @State listPosY: number = 0;
  /**
   * grid开关的数据
   */
  @State gridButtons: Array<string> = [];
  /**
   * grid高度
   */
  @State gridHeight: number = 0;
  @State toggleColumn: number = 5;
  @State mediaShowing: boolean = false;
  @State hasFocusMode: boolean = false;
  @Provide subpageOpacity: number = 0;
  @Provide ccLayoutIndex: ControlCenterLayoutIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
  @Provide privacySensorData: PrivacySensorViewData = new PrivacySensorViewData();
  private lastTopToggles: string = '';
  private lastToggles: string = '';
  private buttonType: HeaderButtonType = HeaderButtonType.NOTHING;
  private style: ControlCenterQuickToggleLayoutStyle = StyleConfiguration.getControlCenterQuickToggleLayoutStyle();
  private componentHeightArray: Array<number> = [];
  /**
   * toast提示
   */
  private showToast = (msg: ResourceStr) => {
    Prompt.showToast({
      message: typeof msg === 'string' ? msg : ResUtils.getInnerString(msg),
      bottom: 80,
      showMode: 2
    });
  }

  aboutToAppear() {
    // 注册监听
    Controller.registerListener();
    // 控制中心状态监听
    sEventManager.subscribe('ControlCenterState', this.onEventMgrStateChange);
    this.onControlCenterStateChanged(ControlCenterState.MAIN_LAYOUT);
    ModeChangeController.getInstance().registerKeyLeftCtrlEvent();
    log.showInfo(TAG, 'aboutToAppear. state: ' + this.data.state);
    AppStorageUtil.setOrCreate('isMarkingRenderGroupOfControl', true, new DataProperty(true, false));
    this.handleToggleDataChanged();
    Controller.setShowToastMethod(this.showToast);
  }

  aboutToDisappear() {
    // 反注册监听
    Controller.unregisterListener();
    sEventManager.off('ControlCenterState', this.onEventMgrStateChange);
    ModeChangeController.getInstance().unRegisterKeyLeftCtrlEvent();
    log.showInfo(TAG, 'aboutToDisappear.');
  }

  private onEventMgrStateChange = (state: ControlCenterState) => {
    this.onControlCenterStateChanged(state);
  }

  handleToggleDataChanged() {
    // 添加头部1*2开关
    this.handleTopToggleData();
    // 添加1*1快捷开关
    this.handleQuickToggleData();
    this.initGrid();
  }

  /**
   * 将头部区域的开关进行排列
   */
  private handleTopToggleData(): void {
    let currentTopToggles: string = this.toggleData.topToggle.join(',');
    if (currentTopToggles === this.lastTopToggles) {
      log.showInfo('top toggles no change');
      return;
    }
    this.lastTopToggles = currentTopToggles;
    // 组装头部开关数组
    this.buildTopToggleArray();
    this.contentIndexArr = this.contentIndexArr.filter(toggle => !toggle.startsWith(TOP_TOGGLE_ROW_ITEM_NAME) &&
      toggle !== ADD_MORE_TOP_BUTTON_NAME);
    for (let i = 0; i < this.topToggleArray.length; i++) {
      this.contentIndexArr.splice(i, 0, TOP_TOGGLE_ROW_ITEM_NAME + '_' + i);
    }
    this.contentIndexArr.splice(this.topToggleArray.length, 0, ADD_MORE_TOP_BUTTON_NAME);
  }

  private buildTopToggleArray(): void {
    let toggleSize: number = this.toggleData.topToggle.length;
    if (toggleSize === 0 || toggleSize > TOP_TOGGLE_MAX) {
      this.topToggleArray = [];
      return;
    }
    let startIndex: number = 0;
    let endIndex: number = 0;
    let numberOf2x2: number = 0;
    let tempTogglesArray: string[][] = [];
    while (endIndex < toggleSize) {
      if (Constants.TOGGLE_LIST_OF_2_2.includes(this.toggleData.topToggle[endIndex])) {
        numberOf2x2++;
      }
      // 如果startIndex到endIndex之间的开关可以凑成一行，即:有2个1x2 或者2个2x2 或者1个2x2加上2个1x2
      if ((endIndex - startIndex == 1 && (numberOf2x2 === 0 || numberOf2x2 === 2)) ||
        (endIndex - startIndex == 2 && numberOf2x2 === 1)) {
        tempTogglesArray.push(this.toggleData.topToggle.slice(startIndex, endIndex + 1));
        startIndex = endIndex + 1;
        numberOf2x2 = 0;
      } else if (endIndex === toggleSize - 1) {
        tempTogglesArray.push(this.toggleData.topToggle.slice(startIndex, endIndex + 1));
      }
      endIndex++;
    }
    this.topToggleArray = tempTogglesArray;
  }

  /**
   * 根据开关数量的变化动态调整quickToggle list数组元素数量
   */
  private handleQuickToggleData(): void {
    let toggleSize: number = this.toggleData.quickToggle.length;
    if (toggleSize === 0 || toggleSize > Constants.PC_MODE_QUICK_TOGGLE_MAX ||
      toggleSize < Constants.PC_MODE_QUICK_TOGGLE_MIN ) {
      log.showInfo('toggleData not initial, return');
      this.quickToggles = [];
      this.lastToggles = '';
      return;
    }
    let currentToggles:string = this.toggleData.quickToggle.join(',');
    if (this.lastToggles === currentToggles) {
      log.showInfo('same with last time');
      return;
    }
    if (this.lastToggles !== '') {
      // 编辑场景，重新加载Lottie资源
      log.showInfo('handleToggleDataChanged initALlLottieData');
      QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
        viewModel.initLottieData();
      });
    }
    this.lastToggles = currentToggles;
    let toggleRowLen: number = Math.ceil(toggleSize / QuickToggleController.getInstance().getToggleColumn());
    this.contentIndexArr = this.contentIndexArr.filter(toggle => !toggle.startsWith(TOGGLE_ROW_ITEM_NAME));
    for (let i = 0; i < toggleRowLen; i++) {
      //  多了一个添加按钮需要加1
      this.contentIndexArr.splice(i + this.topToggleArray.length + 1, 0, TOGGLE_ROW_ITEM_NAME + '_' + i);
    }
    this.toggleData.quickToggle = this.toggleData.quickToggle.filter(
      toggle => !Constants.QUICK_TOGGLE_DELETE_OF_PC_MODE.includes(toggle));
    this.quickToggles = Array.from(this.toggleData.quickToggle);
  }

  /**
   * 初始化Grid
   */
  initGrid() {
    let toggles = Array.from(this.toggleData.quickToggle);
    this.gridButtons = [];
    for (let i = 0; i < toggles.length; i++) {
      this.gridButtons.push(toggles[i]);
    }
    let maxRowCount = Math.ceil(this.gridButtons.length / this.toggleColumn);
    let rowHeight = this.style.buttonDiameter + this.style.buttonLabelSpace +
      this.style.buttonLabelHeight + this.style.buttonMarginBottom + this.style.newIconPadding;
    this.gridHeight = rowHeight * maxRowCount;
  }

  /**
   * 控制中心状态切换回调
   *
   * @param state 新状态值
   */
  onControlCenterStateChanged(state: ControlCenterState): void {
    if (this.data.state === state) {
      log.showInfo(`onControlCenterStateChanged, new state:${state}, same with last.`);
      return;
    }
    if (state === ControlCenterState.MEDIA_CENTER) {
      // pc点击文字弹出二级窗口，并关闭控制中心面板
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      // 设置二级页面窗口位置
      let position = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      let mediaPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL);
      position.width = vp2px(312);
      position.height = mediaPosition.height;
      if (StatusBarType.isMacStyle(AppStorage.get('statusBarType') as number)) {
        let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
        position.left = controlCenterPosition.left + controlCenterPosition.width - position.width;
      }
      let positionCache: Position = {x: position.left, y: 0};
      let winIconArea : Area = {
        width: position.width,
        height: position.height,
        position: positionCache,
        globalPosition: positionCache,
      };
      windowMgr.setStatusIconCaches(PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL, winIconArea);

      EvtBus.post(WindowPositionChangeEvent,
        { windowName: PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL,
          position: PluginPosition.POSITION_RIGHT,
          area: position,
          caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER});
      let pluginInfo: PluginInfo = new PluginInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.pluginIconType = 'mediaPlay'
      windowMgr.setWindowData(PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL, pluginInfo);
      windowMgr.showWindowWithAnim(PluginSlot.SLOT_CONTROL_MEDIA_PLAY_PANEL, true);
      AppStorage.setOrCreate('mediaTransitionDone', true);
    }
    log.showInfo(`onControlCenterStateChanged, new state:${state}`);
    this.controlCenterState = state;
    this.data.state = state;
  }

  build() {
      // 主界面
    this.loadMainLayout();
  }

  /**
   * 隐私指示器
   */
  @Builder
  loadPrivacySensor() {
    PrivacySensor()
      .visibility(this.privacySensorData.isApplicationInterview ? Visibility.Visible : Visibility.None)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let newHeight = Number(newValue.height);
        this.componentHeightArray[INDEX_PRIVACY] = newHeight;
        this.onComponentHeightChanged();
      })
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
          .onAreaChange((oldValue: Area, newValue: Area) => {
            let newHeight = Number(newValue.height);
            if (newHeight > 0) {
              this.componentHeightArray[INDEX_HEADER] = newHeight;
              this.onComponentHeightChanged();
            }
          })

        // 媒体卡片及WIFI蓝牙卡片
        MediaCardLayout({ listPosY: this.listPosY, data: $data })
          .onAreaChange((oldValue: Area, newValue: Area) => {
            let newHeight = Number(newValue.height);
            if (newHeight > 0) {
              this.componentHeightArray[INDEX_MEDIA] = newHeight;
              this.onComponentHeightChanged();
            }
          })

        this.buildBrightnessBar()
        this.buildVolumeBar()
        this.buildGrid()
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
      .visibility(Visibility.Visible)
      .zIndex(0)
  }

  @Builder
  buildGrid() {
    Grid() {
      ForEach(this.gridButtons, (slot: string, index: number) => {
        GridItem() {
          ToggleComponent({
            toggleId: slot,
            toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
            toggleStyle: PCToggleFactory.getInstance().createBasicStyle(),
            templateType: ToggleTemplateType.BASIC,
            toggleScene: ToggleScene.PC
          })
        }
      }, (slot: string) => slot)
    }
    .padding({
      top: $r('app.float.Control_center_quickToggle_padding_vertical_top'),
    })
    .rowsGap(this.style.quickToggleRowsGap)
    .columnsGap(this.style.quickToggleColumnsGap)
    .clip(false)
    .height((this.gridHeight as number) +
    this.style.quickToggleGridBottom)
    .margin({
      bottom: this.style.gridMarginBottom,
      left: this.style.gridMarginLeft,
      right: this.style.gridMarginRight
    })
    .columnsTemplate(QuickToggleController.getInstance().getToggleGridTemplate(this.toggleColumn))
    .rowsTemplate(QuickToggleController.getInstance().getToggleGridTemplate(Math.ceil(this.gridButtons.length /
      this.toggleColumn)))
    .onAreaChange((oldValue: Area, newValue: Area) => {
      let newHeight = Number(newValue.height);
      if (newHeight > 0) {
        this.componentHeightArray[INDEX_QUICK_TOGGLE] = newHeight;
        this.onComponentHeightChanged();
      }
    })
  }

  @Builder
  buildVolumeBar() {
    Volume({
      animationData: this.animationData,
      isLandscapeBrightness: false
    })
      .padding({
        top: $r('app.float.Control_center_brightness_padding_top'),
        bottom: $r('app.float.Control_center_brightness_padding_bottom'),
        start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_bright_padding')))
      })
      .margin({ top: $r('app.float.Control_center_volume_top_margin') })
      .width('100%')
      .height(this.style.brightnessHeight)
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let newHeight = Number(newValue.height);
        if (newHeight > 0) {
          this.componentHeightArray[INDEX_VOLUME] = newHeight;
          this.onComponentHeightChanged();
        }
      })
  }

  @Builder
  buildBrightnessBar() {
    Brightness({
      animationData: this.animationData,
      isLandscapeBrightness: false,
      brightnessFocusable: true,
    })
      .padding({
        top: $r('app.float.Control_center_brightness_padding_top'),
        bottom: $r('app.float.Control_center_brightness_padding_bottom'),
        start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_bright_padding'))),
        end: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_bright_padding')))
      })
      .margin({ top : this.style.brightnessTopMargin })
      .width('100%')
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let newHeight = Number(newValue.height);
        if (newHeight > 0) {
          this.componentHeightArray[INDEX_BRIGHTNESS] = newHeight;
          this.onComponentHeightChanged();
        }
      })
  }

  /**
   * 开关面板列数排布
   *
   * @param column 列数
   */
  getToggleGridTemplate(column: number): string {
    let template = '1fr';
    for (let i = 1; i < column; i++) {
      template += ' 1fr';
    }
    return template;
  }

  onComponentHeightChanged(): void {
    if (this.componentHeightArray.length <= INDEX_QUICK_TOGGLE) {
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
    totalHeight = vp2px(totalHeight + TOTAL_HEIGHT_PADDING);
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
