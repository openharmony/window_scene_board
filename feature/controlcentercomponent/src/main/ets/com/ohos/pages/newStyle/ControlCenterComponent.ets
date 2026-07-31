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

import HeaderLayout from './ControlCenterHeaderLayout';
import lazy { SingleFoldControlCenterComponent } from '../singleFold/SingleFoldControlCenterComponent';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { StorageAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StorageAdapter';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { RectInfo } from '@ohos/basicutils';
import { FASlotName, WindowConstants } from '@ohos/commonconstants'
import {
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  Trace,
  DataProperty,
  AppStorageUtil,
  AnimateToScheduleUtils,
} from '@ohos/basicutils';
import {
  DropDownStatus,
  DeviceHelper,
  sEventManager,
  DropDownEvent,
  TargetPanel,
  TargetChangeState,
  PluginCardChangeEvent,
  WindowEvent,
  EvtBus,
  EventManager,
  ViewType,
} from '@ohos/frameworkwrapper';
import Constants, {
  ControlCenterData,
  ToggleData,
  SUBPAGE_LONG_SPRING_DURATION,
  SUBPAGE_SHORT_SPRING_DURATION,
  TOGGLE_SPACE_DIFF,
  TOGGLE_SPACE_COMPACT,
  HEAD_BLUR_AREA_HEIGHT_COMPACT,
  LINEAR_GRADIENT_PROPORTION_HEADER,
  BLEND_MODE_SRC_IN,
  BLEND_MODE_SRC_OVER,
  MAIN_LAYOUT_HEAD_BLUR_AREA_ZINDEX,
  MAIN_LAYOUT_PRIVACY_SENSOR_ZINDEX,
  MAIN_LAYOUT_HEADER_ZINDEX,
  TOGGLE_LIST_OF_2_2,
  FIXED_TOP_TOGGLES,
  MEDIA_ROW_TOP_TOGGLES,
} from '../../common/Constants';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, { ControlCenterComponentStyle } from '../../common/StyleConfiguration';
import lazy Controller from '../../controller/ControlCenterController';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { SubPageLayout } from './SubPageLayout';
import Curves from '@ohos.curves';
import { ControlListController } from '../../controller/ControlListController';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { IOTSubPageLayout } from './IOTSubPageLayout';
import ControlCenterAnim from '../../common/ControlCenterAnimParm';
import CommonEventManager from '@ohos.commonEventManager';
import account_distributedAccount from '@ohos.account.distributedAccount';
import { BusinessError } from '@ohos.base';
import {
  CC_LAYOUT_CONFIGS,
  ControlCenterLayoutController,
  ControlCenterLayoutIndex
} from '../../controller/ControlCenterLayoutController';
import displaySync from '@ohos.graphics.displaySync';
import uiEffect from '@ohos.graphics.uiEffect';
import type { ExpectedFrameRateRange } from 'ExpectedFrameRateRange';
import PrivacySensor from './PrivacySensor';
import { PrivacySubPageLayout } from './PrivacySubPageLayout';
import { PrivacySensorViewModel } from '../../viewModel/PrivacySensorViewModel';
import { PrivacySensorViewData } from '../../model/PrivacySensorViewData';
import { MultimediaSubPageLayout } from './MultimediaSubPageLayout';
import lazy { ToggleEditView } from '../../view/ToggleEditView';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { ControlCenterHomeViewData } from '../../vm/ControlCenterHomeViewData';
import { ControlCenterHomeViewModel } from '../../vm/ControlCenterHomeViewModel';
import { AnimationDataArray } from '../../model/ControlCenterAnimationData';
import { ControlCenterAnimationViewModel } from '../../viewModel/ControlCenterAnimationViewModel';
import IOTMainPage from './IOTMainPage';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import MediaPlaybackComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaPlaybackComponent';
import {
  DesktopMode,
  EmergencyManager,
  EMERGENCY_TOGGLES,
  EMERGENCY_TOP_TOGGLES } from '../../viewModel/EmergencyManager';
import QuickToggleRow from './QuickToggleRow';
import { AddMoreToggleButton } from '../../view/AddMoreToggleButton';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';
import { ColorInvertTool } from '@ohos/systemuicommon/src/main/ets/utils/ColorInvertTool';
import VisibilityController from '../../controller/ControlCenterVisibilityController'
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import { ControlCenterPanelDropdownEvent } from '../../model/ControlCenterPanelDropdownEvent';
import {
  ControlCenterAccessibilityDataModel
} from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';
import { ControlCenterAnimatingEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';

import BrightnessSubpageLayout from './BrightnessSubpageLayout';
import VolumeSubpageLayout from './VolumeSubpageLayout';
import { LauncherAbilityManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/LauncherAbilityManagerAdapter';
import { ViewManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ViewManagerAdapter';
import { PromptAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/PromptAdapter';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { ScrollBlurViewData } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurViewData';
import { VolumeController } from '@ohos/soundcomponent/src/main/ets/controller/VolumnController';
import BrightLayout from './BrightLayout';
import VolumeLayout from './VolumeLayout';
import { LengthMetrics } from '@kit.ArkUI';
import { curves } from '@kit.ArkUI';
import { FlashlightTipsUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FlashlightTipsUtil';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { PhoneStyleFactory } from '../../phoneStyle/PhoneStyleFactory';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import TopToggleRow from './TopToggleRow';
import { sBrightnessSubPageLayoutController } from '../../controller/BrightnessSubPageLayoutController';
import { soundSubPageController } from '@ohos/soundcomponent';
import { SliderButtonShareData } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import { CloudMode, CloudModeManager } from '../../viewModel/CloudModeManager';
import { DisplayUtils } from '@ohos/screenlockcommon';

const EXPECTED_FRAME_RATE_RANGE: ExpectedFrameRateRange = {
  expected: 120,
  min: 120,
  max: 120
};

const TAG = 'Ctrl.ControlCenterComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

/**
 * 上滑收起面板阈值
 */
const DISTANCE_FOLD_DROPDOWN: number = 5;
const INDEX_HEADER: number = 0;
const DEFAULT_TOUCH_ID: number = -1;
const TOUCH_NUM_MAX: number = 500;
const REQUEST_FOCUS_DELAY: number = 300;
const BOTTOM_HOT_AREA = 32;
const TOP_TOGGLE_ROW_HEIGHT = 80;

/**
 * 主布局隐藏时的参数
 */
const MAIN_PAGE_HIDE_SCALE = 0.95;
const MAIN_PAGE_HIDE_OPACITY = 0.01;

/**
 * Row count of header
 */
const ROW_COUNT_OF_HEADER: number = 2;
const ANI_DELAY: number = 32;
const SUPER_TERMINAL_ITEM_NAME: string = 'superTerminal_brightness';
const FOCUS_ITEM_NAME: string = 'focus_volume';
const TOP_TOGGLE_ROW_ITEM_NAME: string = 'topToggleRow';
const TOGGLE_ROW_ITEM_NAME: string = 'quickToggleRow';
const ADD_MORE_BUTTON_NAME: string = 'addMoreButton';
const ADD_MORE_TOP_BUTTON_NAME: string = 'addMoreTopButton';
const IOT_ITEM_NAME: string = 'iot';
const IOT_TIMEOUT: number = 20000;
const ANIMATING_RESET_TIMEOUT: number = 2000;
const LIST_INIT_CONTENT: string[] =
  [FASlotName.MEDIA_ITEM_NAME, SUPER_TERMINAL_ITEM_NAME, FOCUS_ITEM_NAME, ADD_MORE_BUTTON_NAME, IOT_ITEM_NAME];
const MAX_QUICK_TOGGLE_ROWS: number = 10;

/**
 * 控制中心主页加满开关屏幕下方ListItem行数
 */
const LIST_ITEM_LINES: number = 5;

const HEAD_BLUR_AREA_HEIGHT: number = 124;
const TOGGLE_SPACE: number = 16;
const PADDING_HEIGHT: number = 0;
const ADD_MORE_BUTTON_HEIGHT: number = 78;

// 光影动效辐射范围
const LIGHT_RADIATION_RANGE: number = 100;

// 列表起始偏移
const LIST_START_OFF_SET: number = 132;

/**
 * 控制中心根布局
 */
@Component
export default struct ControlCenterComponent {

  /**
   * toast提示
   */
  private showToast = (msg: ResourceStr) => {
    let message = typeof msg === 'string' ? msg : ResUtils.getInnerString(msg);
    PromptAdapter.showToast(message);
  }

  /**
   * 控制中心数据
   */
  @State data: ControlCenterData = Controller.getData();

  /**
   * 控制中心样式
   */
  @State style: ControlCenterComponentStyle = StyleConfiguration.getControlCenterComponentStyle();
  @State @Watch('setBottomBlankAreaHeight') iotHeight: number = 0;

  /**
   * 是否回收资源
   */
  @Consume trimMemory: boolean;

  /**
   * 是否使用大折叠内屏布局
   */
  private isLargeFoldStyle: boolean = false;

  /**
   * onTouch事件当前起作用的手指id
   */
  private currentTouchId: number = DEFAULT_TOUCH_ID;

  /**
   * onTouch事件当前执行编号
   */
  private currentTouchNo: number = 0;

  /**
   * onTouch事件上一次执行编号
   */
  private lastTouchNo: number = 0;

  /**
   * 智慧生活公共事件监听
   */
  private commonEventSubscriber: CommonEventManager.CommonEventSubscriber | null = null;

  @StorageLink('isLandscape') @Watch('onOrientationChanged') isLandscape: boolean = false;

  /**
   * 下拉事件
   */
  private dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  /**
   * 下拉事件响应式状态
   */
  @State @Watch('onDropdownChanged') dropDownEventState: ControlCenterPanelDropdownEvent = ControlCenterPanelDropdownEvent.create();

  /**
   * Sliding Up Status
   */
  private dropDownStatus: DropDownStatus = DropDownPanelManager.getDropDownStatus();
  private isTouching: boolean = false;
  private progress: number = 0;
  private animationCount: number = 0;

  /**
   * 控制中心ListItem索引集合
   * 默认为6行，即一行媒体卡片 + 三行快捷开关 + 一行亮度条 + 一行IOT卡片
   */
  @State contentIndexArr : string[] = [];

  /**
   * list控制器
   */
  private scroller: Scroller = new Scroller();

  /**
   * 横屏左侧top开关list控制器
   */
  private topToggleScroller: Scroller = new Scroller();
  private isTopListAtEnd: boolean = false;
  private isTopListScroll: boolean = false;

  /**
   * list高度
   */
  @State listHeight: number = 0;

  /**
   * 控制中心高度
   */
  @State contentHeight: number = 0;

  /**
   * y轴方向位移值
   */
  translateY: number = 0;

  /**
   * y轴下拉跟手系数
   */
  transYCoefficient: number = 2 / 3;

  /**
   * Number of control center areas
   */
  @State controlCenterArea: number = 0;

  /**
   * Number of control center Height
   */
  @State controlCenterQuickHeight: number = 0;

  /**
   * item进入、退出时y轴位移
   */
  @State itemTranslateY: Array<number> = [0, 0, 0, 0, 0, 0, 0, 0];

  /**
   * 上一次手指的y坐标
   */
  lastY: number = 0;

  /**
   * 滑动事件X轴起始点
   */
  startX: number = 0;

  /**
   * 滑动事件Y轴起始点
   */
  startY: number = 0;

  /**
   * 是否触底
   */
  listController: ControlListController = new ControlListController();

  mediaCardHeight: number = ResUtils.getNumber($r('app.float.Control_center_mediaAndWifiBlue_height'));

  /**
   * toggle竖屏状态高度
   */
  @State toggleHeight: number = StyleConfiguration.getControlCenterQuickToggleLayoutStyle().togglePanelHeight;

  /**
   * list组件的最后一个可见item的index
   */
  lastIndex: number = 0;

  /**
   * list组件的第一个可见item的index
   */
  firstIndex: number = 0;

  /**
   * 记录List第一个Item高度
   */
  topItemHeight: number = 0;

  /**
   * 前一页面类型
   */
  lastPanelType: TargetPanel = TargetPanel.NONE;

  @State shouldClip: boolean = false;

  @State @Watch('onIotServiceStateChange') isIotServiceAlive: boolean = true;
  @State showIOt: boolean = false;
  @State isIotNeedShow: boolean = false;
  @StorageLink('lockStatus') @Watch('setBottomBlankAreaHeight') lockStatus: number = 0;
  @State isAccountLogin: boolean = false;
  @Provide ccLayoutIndex: ControlCenterLayoutIndex = ControlCenterLayoutIndex.NORMAL_PORTRAIT;
  @StorageLink('foldStatusForOuterScreen')@Watch('onFoldStatusChange') foldStatus: number = AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @State isSmallFoldOuterScreen: boolean = false;
  @Provide @Watch('updateListHeight') privacySensorData: PrivacySensorViewData = new PrivacySensorViewData();
  // 二级页面限高
  @State subpageHeight: number = 0;

  // 用于记录每次滑动开始的时候列表是否是触顶状态
  startWhenListReachTop: boolean = false;

  // 用于记录每次滑动开始的时候列表是否是触底状态
  startWhenListReachBottom: boolean = false;

  @Provide uiExtProxy?: UIExtensionProxy = undefined;
  @StorageLink('isBusinessStyle') isBusinessStyle: boolean = false;

  /**
   * 创建DisplaySync对象，通过此对象设置UI自绘制内容帧率
   */
  private displaySyncObject?: displaySync.DisplaySync;

  @State isEditMode: boolean = false;
  @State viewData: ControlCenterHomeViewData = new ControlCenterHomeViewData();
  @State screenWidth: number = 0;
  @State animationDataArray: AnimationDataArray = new AnimationDataArray();
  private animationViewModel: ControlCenterAnimationViewModel =
    new ControlCenterAnimationViewModel(this.animationDataArray, LIST_INIT_CONTENT.length + MAX_QUICK_TOGGLE_ROWS + 1);
  @State iotDeviceList: number[] = [];
  @State showIotExtension: boolean = false;

  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();

  @StorageLink('needReleaseToggleIcon') needReleaseToggleIcon: boolean = false;
  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('QuickToggleData') @Watch('handleToggleDataChanged') toggleData: ToggleData = QuickToggleController.getInstance().getToggleData();
  @State quickToggles: string[] = [];
  @State topToggleArray: string[][] = [];
  @State @Watch('onDesktopModeChange') desktopMode: DesktopMode = EmergencyManager.getInstance().getData();
  @State @Watch('onCloudModeChange') CloudMode: CloudMode = CloudModeManager.getInstance().getData();

  // 底部点击收起的空白区域高度
  @State tapBlankAreaHeight: number = 0;
  // 底部点击收起的空白区域宽度
  @State tapBlankAreaWidth: string | number = '100%';
  // 底部上滑收起的空白区域高度
  @State slideUpBlankAreaHeight: number = 0;
  // 底部上滑收起的空白区域宽度
  @State slideUpBlankAreaWidth: string | number = '100%';
  @State isShowTerminalButton: boolean = LauncherAbilityManagerAdapter.getUserId() === Constants.DEFAULT_USER_ID;
  private isIotLoadCache: boolean = false;
  private releaseIotTimeout: number = 0;
  private eventMgr: EventManager = EvtBus.createEventManager();

  private lastTopToggles: string = '';
  private lastToggles: string = '';
  private toggleAreaHeight: number = 0;
  // 是否向下滑动过
  private hasScrollDown: boolean = false;

  private scrollBlurController?: ScrollBlurController;
  private blurArea: RectInfo = new RectInfo();
  @State scrollBlurViewData: ScrollBlurViewData = new ScrollBlurViewData();
  private homeViewModel: ControlCenterHomeViewModel = new ControlCenterHomeViewModel(this.viewData, this.scroller);

  @State openChain: boolean = true;
  @Provide subpageOpacity: number = 0;
  private isHideAnimStarted: boolean = false;

  private mediaTransitionLink: AbstractProperty<number> = AppStorage.setAndRef('mediaTransitionFlag', 0);

  private relativeDistance: number = 0;
  private screenHeight: number = 0;
  @State isListFocused: boolean = false;


  /**
   * 隐私指示器父组件高度,避免组件被遮挡后自动化工具无法读取
   */
  private privacySensorParentComponentHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height')) + 1;
  @State controlCenterAnimating: boolean = false;
  private animatingResetFlag: number = -1;
  /**
   * main list是否正在滑动
   */
  @State isListMoving: boolean = false;

  @StorageLink('isFoldExpanded') isExpanded: boolean = false;

  private filter: uiEffect.Filter = uiEffect.createFilter();

  handleToggleDataChanged() {
    if (this.desktopMode.desktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      return;
    } else if (this.CloudMode.isOutdoorCloudMode || this.CloudMode.isOutDoorCloudMode) {
      return;
    }
    // 添加头部1*2开关
    this.handleTopToggleData();
    // 添加1*1快捷开关
    this.handleQuickToggleData();
    // 添加Iot
    this.handleIotData();

    this.setBottomBlankAreaHeight();
    this.animationViewModel.updateViewDataArray(this.contentIndexArr.length + 1, Controller.isControlCenterVisible());
    log.showInfo('handleToggleDataChanged: %{public}s', this.contentIndexArr.toString());
  }

  /**
   * 将头部区域的开关进行排列
   */
  private handleTopToggleData(): void {
    let currentTopToggles: string = this.toggleData.topToggle.join(',');
    // 顶栏为空时 lastTopToggles 初始也为空，若直接 return 会漏插 ADD_MORE_TOP，快捷行索引整体错位
    if (currentTopToggles === this.lastTopToggles &&
      this.contentIndexArr.includes(ADD_MORE_TOP_BUTTON_NAME)) {
      log.showInfo('top toggles no change');
      return;
    }
    this.lastTopToggles = currentTopToggles;
    // 组装头部开关数组
    this.buildTopToggleArray();
    log.showInfo(`buildTopToggleArray ${this.topToggleArray.toString()}`)
    this.contentIndexArr = this.contentIndexArr.filter(toggle => !toggle.startsWith(TOP_TOGGLE_ROW_ITEM_NAME) &&
      toggle !== ADD_MORE_TOP_BUTTON_NAME);
    for (let i = 0; i < this.topToggleArray.length; i++) {
      this.contentIndexArr.splice(i, 0, TOP_TOGGLE_ROW_ITEM_NAME + '_' + i);
    }
    this.contentIndexArr.splice(this.topToggleArray.length, 0, ADD_MORE_TOP_BUTTON_NAME);
  }

  private buildTopToggleArray(): void {
    let toggleSize: number = this.toggleData.topToggle.length;
    if (toggleSize === 0) {
      this.topToggleArray = [];
      return;
    }
    // 媒体/亮度/音量固定为同一行且顺序为：媒体 | 亮度 | 音量
    const mediaRow: string[] = MEDIA_ROW_TOP_TOGGLES.filter(item => this.toggleData.topToggle.includes(item));
    const otherToggles: string[] = this.toggleData.topToggle.filter(item => !MEDIA_ROW_TOP_TOGGLES.includes(item));
    let tempTogglesArray: string[][] = [];
    if (mediaRow.length > 0) {
      tempTogglesArray.push(mediaRow);
    }
    let startIndex: number = 0;
    let endIndex: number = 0;
    let numberOf2x2: number = 0;
    toggleSize = otherToggles.length;
    while (endIndex < toggleSize) {
      if (TOGGLE_LIST_OF_2_2.includes(otherToggles[endIndex])) {
        numberOf2x2++;
      }
      // 如果startIndex到endIndex之间的开关可以凑成一行，即:有2个1x2 或者2个2x2 或者1个2x2加上2个1x2
      if ((endIndex - startIndex === 1 && (numberOf2x2 === 0 || numberOf2x2 === 2)) ||
        (endIndex - startIndex === 2 && numberOf2x2 === 1)) {
        tempTogglesArray.push(otherToggles.slice(startIndex, endIndex + 1));
        startIndex = endIndex + 1;
        numberOf2x2 = 0;
      } else if (endIndex === toggleSize - 1) {
        tempTogglesArray.push(otherToggles.slice(startIndex, endIndex + 1));
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
    if (toggleSize === 0) {
      log.showInfo('toggleData not initial, return');
      this.quickToggles = [];
      this.lastToggles = '';
      return;
    }
    let currentToggles:string = this.toggleData.quickToggle.join(',');
    let toggleRowLen: number = Math.ceil(toggleSize / QuickToggleController.getInstance().getToggleColumn());
    // 顶栏行数变化时也需重建快捷行占位，否则 getQuickToggleRow 起始下标会错位导致少显示整行
    let expectedQuickRows: number = 0;
    this.contentIndexArr.forEach((item: string) => {
      if (item.startsWith(TOGGLE_ROW_ITEM_NAME)) {
        expectedQuickRows++;
      }
    });
    if (this.lastToggles === currentToggles && expectedQuickRows === toggleRowLen) {
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
    this.toggleAreaHeight = toggleRowLen * 100;
    this.contentIndexArr = this.contentIndexArr.filter(toggle => !toggle.startsWith(TOGGLE_ROW_ITEM_NAME));
    for (let i = 0; i < toggleRowLen; i++) {
      //  多了一个添加按钮需要加1
      this.contentIndexArr.splice(i + this.topToggleArray.length + 1, 0, TOGGLE_ROW_ITEM_NAME + '_' + i);
    }
    this.quickToggles = Array.from(this.toggleData.quickToggle);
    DropDownPanelManager.updateQuickToggleData(currentToggles);
  }

  private handleIotData(): void {
    if (this.contentIndexArr.length === 0 ||
      !this.contentIndexArr[this.contentIndexArr.length - 1]?.startsWith(IOT_ITEM_NAME)) {
      this.contentIndexArr.push(ADD_MORE_BUTTON_NAME);
    } else {
      this.contentIndexArr.pop();
    }
    this.contentIndexArr.push(IOT_ITEM_NAME + this.contentIndexArr.length);
  }

  onCloudModeChange() {
    if (this.CloudMode.isOutdoorCloudMode || this.CloudMode.isOutDoorCloudMode) {
      this.handleCloudMode();
    } else {
      log.showInfo('out CloudMode');
      this.handleToggleDataChanged();
    }
  }

  handleCloudMode() {
    const cloudToggles = CloudModeManager.CLOUD_TOGGLES;
    const cloudTopToggleArr = CloudModeManager.CLOUD_TOP_TOGGLES_ARRAY;
    this.quickToggles = cloudToggles;
    this.topToggleArray = cloudTopToggleArr;
    this.lastToggles = this.quickToggles.join(',');
    this.lastTopToggles = this.topToggleArray.join(',');
    let currentToggles:string = this.toggleData.quickToggle.join(',');
    DropDownPanelManager.updateQuickToggleData(currentToggles);
    this.contentIndexArr = CloudModeManager.CLOUD_CONTENT_INDEX_ARR;
    this.animationViewModel.updateViewDataArray(this.contentIndexArr.length + 1, Controller.isControlCenterVisible());
    let toggleRowLen: number = Math.ceil(cloudToggles.length / QuickToggleController.getInstance().getToggleColumn());
    this.toggleAreaHeight = toggleRowLen * 100;
    this.setBottomBlankAreaHeight();
  }

  onDesktopModeChange() {
    if (this.desktopMode.desktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      log.showInfo('into emergency');
      this.quickToggles = EMERGENCY_TOGGLES;
      this.topToggleArray = [EMERGENCY_TOP_TOGGLES];
      this.lastToggles = this.quickToggles.join(',');
      this.lastTopToggles = this.topToggleArray.join(',');
      EMERGENCY_TOGGLES.forEach(
        toggle => QuickToggleController.getInstance().allTogglesControllerMap.get(toggle)?.initLottieData());
      EMERGENCY_TOP_TOGGLES.forEach(
        toggle => QuickToggleController.getInstance().allTogglesControllerMap.get(toggle)?.initLottieData());
      this.contentIndexArr = ['topToggleRow_0', 'addMoreTopButton', 'quickToggleRow_0'];
      this.animationViewModel.updateViewDataArray(this.contentIndexArr.length + 1, Controller.isControlCenterVisible());
      this.setBottomBlankAreaHeight();
    } else if (this.CloudMode.isOutdoorCloudMode || this.CloudMode.isOutDoorCloudMode) {
      this.handleCloudMode();
    }
    else {
      log.showInfo('out emergency');
      this.handleToggleDataChanged();
    }
  }

  onControlCenterStateChangedCallback = (state: ControlCenterState) => {
    this.onControlCenterStateChanged(state);
  }

  aboutToAppear() {
    this.onDesktopModeChange();
    this.onCloudModeChange();
    this.displaySyncObject = displaySync.create();
    // 设置DisplaySync期望的帧率
    this.displaySyncObject?.setExpectedFrameRateRange(EXPECTED_FRAME_RATE_RANGE);
    // 注册监听
    Controller.registerListener();
    // 控制中心状态监听
    sEventManager.subscribe('ControlCenterState', this.onControlCenterStateChangedCallback);
    this.onControlCenterStateChanged(ControlCenterState.MAIN_LAYOUT);
    this.handleToggleDataChanged();
    log.showInfo('aboutToAppear. state: ' + this.data.state);
    // 双中心切换，主动触发回调，执行动画
    if (this.dropDownEventState.targetChanged != TargetChangeState.NONE) {
      this.onDropdownChanged();
    }
    AppStorageUtil.setOrCreate('isMarkingRenderGroupOfControl', true, new DataProperty(true, false));

    ControlCenterLayoutController.getInstance().setLayoutChangeCallback('controlCenterLayout', (newIndex, prop?) => {
      log.showInfo(`ccLayoutIndex:${newIndex}`);
      this.ccLayoutIndex = newIndex;
      this.isLargeFoldStyle = this.ccLayoutIndex === ControlCenterLayoutIndex.FOLD_EXPANDED;
      this.screenWidth = prop?.width ?? this.screenWidth;
      log.showInfo(`screenWidth:${this.screenWidth} screenHeight：${this.screenHeight}`);
      this.listHeight = this.screenHeight - this.getMainPageOffset() +
        (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset as number ?? 0);
      this.contentHeight = this.screenHeight - (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset ?? 0);
      this.setBottomBlankAreaHeight();
      if (newIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
        this.scrollBlurController?.disableScrollBlur();
      } else {
        this.scrollBlurController?.enableScrollBlur();
        this.scrollBlurController?.setScrollToIndex();
        this.topToggleScroller.scrollToIndex(0);
      }
    });
    Controller.setHomeViewData(this.viewData);
    Controller.setShowToastMethod(this.showToast);

    this.iotAccountLogin();
    this.iotCacheUpdateEvent();
    Controller.setDefaultBrightening();

    this.blurArea.left = 0;
    this.blurArea.top = 0;
    this.blurArea.height = HEAD_BLUR_AREA_HEIGHT;
    this.blurArea.width = this.screenWidth;
    this.scrollBlurController = new ScrollBlurController(this.scroller, LIST_START_OFF_SET);
    this.scrollBlurController?.init(this.blurArea, this.scrollBlurViewData);
    this.homeViewModel.setScrollBlurController(this.scrollBlurController);
    this.onFoldStatusChange();

    // 页面动画进行中标志位监听
    this.eventMgr.on(ControlCenterAnimatingEvent, (event: ControlCenterAnimatingEvent) => {
      log.showInfo(`update controlCenterAnimating Event=${event.controlCenterAnimating} controlCenterAnimating=${this.controlCenterAnimating}`);
      this.controlCenterAnimating = event.controlCenterAnimating;
      if (this.controlCenterAnimating) {
        if (this.animatingResetFlag !== -1) {
          clearTimeout(this.animatingResetFlag);
        }
        this.animatingResetFlag = setTimeout(() => {
          log.showInfo(`animatingReset controlCenterAnimating=${this.controlCenterAnimating}`);
          this.controlCenterAnimating = false;
          this.animatingResetFlag = -1;
        }, ANIMATING_RESET_TIMEOUT);
      }
    })

    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      // 隐藏下拉窗口
      if (event.windowName === WindowConstants.WINDOW_NAME_DROPDOWN &&
        event.eventType === WindowEvent.EVENT_TYPE_HIDE) {
        this.shouldClip = false;
      }

      // 展开下拉窗口
      if (event.windowName === WindowConstants.WINDOW_NAME_DROPDOWN &&
        event.eventType === WindowEvent.EVENT_TYPE_SHOW) {
        this.shouldClip = false;
      }
    });
  }

  aboutToDisappear() {
    ControlCenterLayoutController.getInstance().setLayoutChangeCallback('controlCenterLayout', undefined);
    // 反注册监听
    Controller.unregisterListener();
    Controller.setHomeViewData(undefined);
    Controller.setShowToastMethod(undefined);
    EmergencyManager.getInstance().unRegisterDesktopModeChange();
    CloudModeManager.getInstance().unRegisterDesktopModeChange();
    this.eventMgr?.offAll();
    this.scrollBlurController?.unregister();
    VolumeController.getInstance().releaseVolumeChangeCallback();
    CommonEventManager.unsubscribe(this.commonEventSubscriber);
    this.commonEventSubscriber = null;
    sEventManager.off('ControlCenterState', this.onControlCenterStateChangedCallback);
    log.showInfo('aboutToDisappear.');
  }

  build() {
    Stack() {
      Stack() {
        // 隐私指示器
        this.loadPrivacySensor()
        // Header
        if (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.isShowHeaderLayout) {
          this.loadHeaderLayout();
        }
        // 点击和上滑空白处收起
        this.loadClickAndSlideUpBackboard();
        // 主界面
        this.loadMainLayout();
        // home手势背板
        this.loadHomeGestureBackboard();
        if (this.viewData.loadEditPage) {
          this.loadToggleEditLayout();
        }
        // DisplayUtils.getFoldStatus()获取屏幕折叠状态,0:未知,1:当前折叠状态为完全展开
        if (this.controlCenterState === ControlCenterState.SUB_PANEL &&
        sToggleSubWindowController.getCurrentSubPanelSlot() && (DisplayUtils.getFoldStatus() === 0 || 1)) {
          // 二级界面
          if (this.updateSubpageHeight()) {
          }
          SubPageLayout({
            contentHeight: this.subpageHeight,
            listHeight: this.listHeight
          })
            .id('transition_subpage' + sToggleSubWindowController.getCurrentSubPanelSlot())
            .transition(TransitionEffect
              .opacity(0.99)
              .animation({duration: SUBPAGE_LONG_SPRING_DURATION, curve: Curve.Friction}))
            .gesture(PanGesture({ direction: PanDirection.Horizontal }))
        } else if (this.controlCenterState === ControlCenterState.MEDIA_CENTER && (DisplayUtils.getFoldStatus() === 0 || 1)) {
          this.loadMediaCenterLayout();
        } else if (this.controlCenterState === ControlCenterState.SOUND_SUB_PAGE) {
          if (this.updateSubpageHeight()) {}
          VolumeSubpageLayout({ contentHeight: this.subpageHeight })
            .id('transition_subpage_VolumeSubpageLayout')
            .transition(TransitionEffect
              .opacity(0.99)
              .animation({ duration: SUBPAGE_SHORT_SPRING_DURATION, curve: Curve.Friction }))
            .gesture(PanGesture({ direction: PanDirection.Horizontal }))
        } else if (this.controlCenterState === ControlCenterState.BRIGHTNESS_SUBPAGE) {
          if (this.updateSubpageHeight()) {
          }
          BrightnessSubpageLayout({
            contentHeight: this.subpageHeight,
          })
            .id('transition_subpage_BrightnessSubpageLayout')
            .transition(TransitionEffect
              .opacity(0.99)
              .animation({duration: SUBPAGE_SHORT_SPRING_DURATION, curve: Curve.Friction}))
            .gesture(PanGesture({ direction: PanDirection.Horizontal }))
        } else if (this.controlCenterState === ControlCenterState.IOT_SUB_PAGE) {
          this.loadIOTSubPageLayout();
        } else if (this.controlCenterState == ControlCenterState.PRIVACY_SUB_PAGE) {
          this.loadPrivacySubPageLayout();
        } else if (this.controlCenterState == ControlCenterState.MULTIMEDIA_SUB_PAGE) {
          this.loadMultimediaSubPageLayout();
        }

        this.HeadBlurArea()
      }
      .direction(Direction.Ltr)
      .width('100%')
      .height('100%')
      .alignContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelAlignment)
    }
    .gesture(PanGesture({ direction: PanDirection.Horizontal })
      .onActionStart((event?: GestureEvent): void => DropDownPanelManager.onPanActionStart(event))
      .onActionUpdate((event?: GestureEvent): void => DropDownPanelManager.onPanActionUpdate(event))
      .onActionEnd((event?: GestureEvent): void => DropDownPanelManager.onPanActionEnd(event as GestureEvent, true))
      .onActionCancel((event?: GestureEvent): void => DropDownPanelManager.onPanActionEnd(event as GestureEvent, true))
    )
  }

  @Builder
  HeadBlurArea() {
    Column() {
      Column()
        .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.headBlurAreaWidth ?? this.screenWidth)
        .height(this.blurArea.height)
        .compositingFilter(this.scrollBlurController?.getBlurCompositingFilter(this.filter))
        .blendMode(BLEND_MODE_SRC_IN);
    }
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.headBlurAreaWidth ?? this.screenWidth)
    .height(this.blurArea.height)
    .compositingFilter(this.scrollBlurController?.getBlurCompositingFilter(this.filter))
    .linearGradient({
      angle: 270, colors: [['rgba(0, 0, 0, 1)', 0],
        ['rgba(0, 0, 0, 1)', LINEAR_GRADIENT_PROPORTION_HEADER],
        ['rgba(0, 0, 0, 0)', 1]]
    })
    .blendMode(BLEND_MODE_SRC_OVER, BlendApplyType.OFFSCREEN) // 启离屏
    .visibility(this.scrollBlurViewData.getBlurActive() ? Visibility.Visible : Visibility.Hidden)
    .zIndex(MAIN_LAYOUT_HEAD_BLUR_AREA_ZINDEX)
    .accessibilityLevel('yes')
  }

  getMainLayoutOpacity(): number {
    if (this.data.state === ControlCenterState.MEDIA_CENTER) {
      TraceUtil.endTrace(DomainName.CC, 'OPACITY_MAIN');
    }
    return this.data.state === ControlCenterState.MAIN_LAYOUT ? 1 : MAIN_PAGE_HIDE_OPACITY;
  }

  /**
   * 加载主界面布局
   */
  @Builder
  loadMainLayout() {
    Stack({alignContent: Alignment.Top}) {
      Flex({
        direction: CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.flexDirection,
        alignItems: CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.flexAlignItems,
        justifyContent: CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.flexJustifyContent,
        space: { main: LengthMetrics.vp(32)}
      }) {
        if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
          this.loadTopToggleList();
        }
        this.loadMainList();
      }
      .height(!CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.isShowHeaderLayout ? '100%' :
        `calc(100% + ${CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset ?? 0}vp)`)
      .opacity(this.data.state === ControlCenterState.MAIN_LAYOUT ? 1 : MAIN_PAGE_HIDE_OPACITY)
      .margin({top: this.getMainPageOffset()})
      .onTouch((event?: TouchEvent) => this.onListTouchEvent(event as TouchEvent))
    }
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      log.showInfo('onSizeChange: %{public}d', newValue.height);
      // 更新容器高度
      let newValueHeight = Number(newValue.height);
      this.screenHeight = newValueHeight;
      this.listHeight = newValueHeight - this.getMainPageOffset() +
        (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset as number ?? 0);
      this.contentHeight = newValueHeight - (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset ?? 0);
      this.setBottomBlankAreaHeight();
    })
    .height('100%')
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.mainPanelWidth)
    .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.mainPanelMargin)
    .scale(this.data.state === ControlCenterState.MAIN_LAYOUT ?
      { x: 1, y: 1, centerY: this.contentHeight * 0.5 + 'vp' } :
      { x: MAIN_PAGE_HIDE_SCALE, y: MAIN_PAGE_HIDE_SCALE, centerY: this.contentHeight * 0.5 + 'vp' })
    .accessibilityLevel(this.data.state === ControlCenterState.MAIN_LAYOUT ? 'auto' : 'no-hide-descendants')
    .focusable(this.data.state === ControlCenterState.MAIN_LAYOUT)
  }

  @Styles
  ListStyle() {
    .height(this.listHeight)
    .clip((this.shouldClip || this.viewData.shouldClipHeadArea) ?
      new Rect(this.getClipReact()).position({
      x: -LIGHT_RADIATION_RANGE,
      y: this.shouldExcludeHeader() ? HEAD_BLUR_AREA_HEIGHT : 0 }) : false
    )
    .padding(this.screenWidth && CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.scrollPadding)
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.scrollWidth)
  }

  private getClipReact(): RectOptions | RoundedRectOptions {
    if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_PORTRAIT &&
    this.listHeight < 700) {
      this.updateListHeight();
      return {
        width: this.screenWidth + LIGHT_RADIATION_RANGE * 2,
        height: 1500
      };
    }
    return {
      width: this.screenWidth + LIGHT_RADIATION_RANGE * 2,
      height: this.listHeight - (this.shouldExcludeHeader() ? HEAD_BLUR_AREA_HEIGHT : 0)
    };
  }

  /**
   * 剪切列表时是否需要排除头部区域
   * @returns
   */
  private shouldExcludeHeader(): boolean {
    return CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.isShowHeaderLayout &&
      (this.viewData.shouldClipHeadArea || !this.scrollBlurController?.getScrollBlurEnableState());
  }

  // 开关主列表（包含横屏下的快捷开关列表）
  @Builder
  loadMainList() {
    List({ scroller: this.scroller, space: TOGGLE_SPACE }) {
      this.ForEachBuilder()
      this.BlankArea()
    }
    .id(TAG + '_MainList')
    .onFocus(() => {
      if (!this.isListFocused) {
        this.isListFocused = true;
      }
      if (!this.shouldClip && this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
        this.shouldClip = true;
      }
    })
    .onBlur(() => {
      if (this.isListFocused) {
        this.isListFocused = false;
      }
    })
    .contentEndOffset(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset ?? 0)
    .contentStartOffset(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset ?? 0)
    .scrollBar(BarState.Off)
    .chainAnimation(this.openChain)
    .cachedCount(LIST_ITEM_LINES, true)
    .chainAnimationOptions({
      minSpace: 12,
      maxSpace: 32,
      edgeEffect: ChainEdgeEffect.STRETCH
    })
    .enableScrollInteraction(this.viewData.blankLayoutWeight === 1)
    .alignListItem(this.isLargeFoldStyle ? ListItemAlign.End : ListItemAlign.Center)
    .ListStyle()
    .onGestureJudgeBegin((gestureInfo: GestureInfo, event: BaseGestureEvent) => {
      if (this.data.state === ControlCenterState.IOT_SUB_PAGE) {
        return GestureJudgeResult.REJECT;
      }
      return GestureJudgeResult.CONTINUE;
    })
    .onScrollStart(() => {
      log.showInfo('onScrollStart');
      this.uiExtProxy?.send({ 'method': 'canClick', 'param': 0, });
      this.shouldClip = true;
      AppStorage.setOrCreate('isToggleLightEnabled', false);
    })
    .onReachStart(() => {
      log.showInfo(`onReachStart`);
      this.listController.isReachTop = true;
    })
    .onDidScroll(() => {
      if (this.isScrollByFocus()) {
        this.scrollBlurController?.onListScrollWithBlurAnimate();
      }
      // 在下拉停止时处理头部区域位置，避免出现头部区域不复位
      this.headerFollowEffect();
    })
    .onWillScroll((scrollOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
      if (scrollOffset === 0) {
        log.showInfo('not deal with zero return');
        return;
      }
      if (scrollOffset > 0 && this.listController.isReachTop) {
        this.listController.isReachTop = false;
      }
      // 不处理Scroller的方法触发的回调
      if (scrollSource === ScrollSource.SCROLLER) {
        log.showInfo('handleOnWillScroll from scroller')
        return;
      }
      return this.handleOnWillScroll(scrollOffset);
    })
    .onScrollStop(() => {
      log.showInfo('onScrollStop');
      this.uiExtProxy?.send({ 'method': 'canClick', 'param': 1, });
    })
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
    .enabled(!this.controlCenterAnimating)
  }

  private isScrollByFocus(): boolean {
    return !this.homeViewModel.getIsEditing() && !this.isTouching &&
      !this.isHideAnimStarted && this.dropDownEvent.progress === 1;
  }

  private handleOnWillScroll(scrollOffset: number): void | ScrollResult {
    this.headerFollowEffect();
    if (this.startWhenListReachBottom && this.startWhenListReachTop) {
      // 不超一屏的时候，向上滑动收起，为了保持收起动效正常，列表不滚动
      try {
        if (!this.hasScrollDown &&
          Math.round(this.scroller.getItemRect(0).y) <=
            (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset as number) &&
          this.relativeDistance < 0) {
          this.scrollBlurController?.inactiveScrollerBlur();
          this.shouldClip = false;
          this.openChain = false;
          let res: ScrollResult = { offsetRemain: 0 };
          return res;
        }
      } catch (err) {
        log.showError(`handleOnWillScroll error, Cause: ${err}`);
      }
      // 不超一屏的时候，需要有跟手拖拽越界回弹效果
      this.scrollBlurController?.onListScrollWithBlur();
      let res: ScrollResult = { offsetRemain: scrollOffset };
      return res;
    }
    // 超一屏的时候，从底部开始向上滑动，为了保持收起动效正常，列表不滚动
    if (!this.hasScrollDown && this.startWhenListReachBottom &&
    this.scroller.isAtEnd() && this.relativeDistance < 0 && scrollOffset > 0) {
      this.openChain = false;
      let res: ScrollResult = { offsetRemain: 0 };
      return res;
    }
    // 超一屏的时候，滑动和跟手拖拽越界回弹效果
    if (!this.isHideAnimStarted && this.data.state === ControlCenterState.MAIN_LAYOUT) {
      this.scrollBlurController?.onListScrollWithBlur();
    }
    let res: ScrollResult = { offsetRemain: scrollOffset };
    return res;
  }

  @Builder
  ForEachBuilder() {
    ForEach(this.contentIndexArr, (item: string, index: number) => {
      if (this.needBuildItem(item)) {
        this.loadEachItem(item);
      }
    }, (item: string, index?: number) => item)
  }

  /**
   * 通过item获取对应的index，在开关行数变化的时候刷新变化行的开关
   * @param item 控制中心列表行
   * @returns
   */
  private getItemIndex(item: string): number {
    let index: number = this.contentIndexArr.indexOf(item);
    log.showInfo(`getItemIndex item: ${item} index: ${index}`)
    if (index < 0) {
      return 0;
    }
    return index;
  }

  private needBuildItem(item: string): boolean {
    if (item.startsWith(TOP_TOGGLE_ROW_ITEM_NAME) && this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      return false;
    }
    return true;
  }

  @Builder
  BlankArea() {
    if (this.viewData.blankLayoutWeight < 1) {
      ListItem() {
      }
      .height('100%')
      .width('100%')
    }
    if (this.showIOt && this.iotHeight !== 0) {
      this.IotBottomBlankArea();
    }
  }

  // 之所以分开在onScroll处理头部按钮的跟随效果，因为onScrollFrameBegin在过界回弹的时候收不到回调，后续sdk升级可用onWillScroll代替
  private headerFollowEffect() {
    log.showDebug(`headerFollowEffect ${this.animationDataArray[INDEX_HEADER].translate}`);
    if (this.ccLayoutIndex != ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      try {
        let rectInfo = this.scroller.getItemRect(0);
        if (Math.round(rectInfo.y) > (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset as number)) {
          this.animationDataArray[INDEX_HEADER].translate =
            (rectInfo.y - (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset as number)) * 0.95;
        } else {
          this.animationDataArray[INDEX_HEADER].translate = 0;
          this.isListMoving = false;
        }
      } catch (error) {
        log.showError(`headerFollowEffect error, Cause: ${error}`);
      }
    } else {
      this.animationDataArray[INDEX_HEADER].translate = 0;
      this.isListMoving = false;
    }
  }

  @Builder
  IotBottomBlankArea() {
    ListItem() {
      // 如果有IOT卡片，则底部填充margin
      Column()
        .height(this.style.iotMarginBottom - 16) // 减去列表item之间的边距16
        .width('100%')
        .offset({y : this.iotHeight !== 0 && this.lockStatus === 1 ? -16 : 0})
        .focusable(false)
        .onClick((event?: ClickEvent) => {
          if (!this.dropDownStatus.isTouchingStatusBar && !this.isTouching) {
            log.showInfo('When there are IoT cards, hide cc by click bottom blank area');
            DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
            DropDownPanelManager.animToDismiss();
          }
        }).accessibilityLevel('no');
    }
  }

  buildItem(item: string) : boolean {
    log.showInfo('build Item:' + item);
    return true;
  }

  @Builder
  loadEachItem(item: string) {
    if (item.startsWith(TOP_TOGGLE_ROW_ITEM_NAME)) {
      ListItem() {
        TopToggleRow({
          animationData: this.animationDataArray[this.getItemIndex(item) + 1],
          slots: this.getTopToggleRow(this.getItemIndex(item)),
          viewData: this.viewData,
          contentHeight: this.contentHeight
        })
          .id('Ctrl.TopToggleRow_' + this.getItemIndex(item))
      }
      .offset({ y: this.isListFocused && this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ? 4 : 0 })
    } else if (item.startsWith(TOGGLE_ROW_ITEM_NAME)) {
      ListItem() {
        QuickToggleRow({
          animationData: this.animationDataArray[this.getQuickToggleRowIndex(this.getItemIndex(item))],
          slots: this.getQuickToggleRow(this.quickToggles, this.getItemIndex(item))
        })
          .id('Ctrl.QuickToggleRow_' + this.getItemIndex(item))
          .visibility(VisibilityController.getToggleRowVisibility(this.backgroundOpacity.backgroundOpacity));
      }
      .offset({ y: this.isListFocused && this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ? 4 : 0 })
    } else if (this.needShowIotPage(item) || item.startsWith(IOT_ITEM_NAME)) {
      ListItem() {
        this.loadIOTMainPage(this.getItemIndex(item) - 1);
      }
      .offset({ y: this.isListFocused && this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE ? 4 : 0 })
    } else if (item.startsWith(ADD_MORE_BUTTON_NAME) && this.viewData?.showAddMoreButton) {
      ListItem() {
        AddMoreToggleButton()
          .transition(TransitionEffect.OPACITY.animation({ duration: 350, curve: Curve.Friction }))
      }
      .align(Alignment.Top)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight)
    } else if (item === ADD_MORE_TOP_BUTTON_NAME && this.viewData?.showAddMoreButton) {
      ListItem() {
        AddMoreToggleButton()
          .transition(TransitionEffect.OPACITY.animation({ duration: 350, curve: Curve.Friction }))
      }
      .align(Alignment.Top)
      .height(ADD_MORE_BUTTON_HEIGHT)
    }
  }

  private getTopToggleRow(index: number): string[] {
    if (index < 0 || index >= this.topToggleArray.length) {
      log.showWarn('index is not normal: ' + index);
      return [];
    }
    return this.topToggleArray[index];
  }

  private getQuickToggleRowIndex(index: number): number {
    let targetIndex: number =
      CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.isShowHeaderLayout ? index : index - this.topToggleArray.length;
    if (targetIndex >= this.animationDataArray.length) {
      targetIndex = this.animationDataArray.length - 1;
    }
    if (targetIndex < 0) {
      targetIndex = 0;
    }
    return targetIndex;
  }

  private getQuickToggleRow(arr: string[], index: number): string[] {
    // 开关的起始行数是index = 头部开关行数+1个添加开关的占位行
    let topToggleRow: number = this.topToggleArray.length + 1;
    let startIndex = index - topToggleRow;
    if (startIndex < 0) {
      log.showWarn(`getQuickToggleRow index is ${index} less than ${topToggleRow}`);
      startIndex = 0;
    }
    log.showInfo(`getQuickToggleRow: topToggleRow ${topToggleRow}, ${arr.toString()},  ${startIndex}`);
    let start = startIndex * QuickToggleController.getInstance().getToggleColumn();
    let end = start + QuickToggleController.getInstance().getToggleColumn();
    let resArr = arr.slice(start, end);
    return resArr;
  }

  @Builder
  toggleLoader(slot: string, isDragging: boolean) {
    ToggleComponent({
      toggleId: slot,
      toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
      toggleStyle: PhoneStyleFactory.getInstance().createBasicStyle(),
      templateType: ToggleTemplateType.BASIC,
      isEditMode: true,
      toggleScene: ToggleScene.PHONE
    })
      .accessibilityGroup(this.isEditMode && this.isAccessibilityMode)
      .accessibilityLevel(this.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
  }

  /**
   * 加载快捷开关编辑界面布局
   */
  @Builder
  loadToggleEditLayout() {
    ToggleEditView({
      isEditMode: this.isEditMode,
      screenWidth: this.screenWidth,
      toggleLoader: this.toggleLoader,
      iotHeight: this.iotHeight,
      showToast: this.showToast,
      previewToggles: Array.from(this.toggleData.quickToggle),
      libraryToggles: Array.from(this.toggleData.otherToggle),
      previewTopToggles: this.toggleData.topToggle.filter(item => !FIXED_TOP_TOGGLES.includes(item)),
      libraryTopToggles: Array.from(this.toggleData.otherTopToggle),
    })
      .zIndex(1)
      .visibility(this.viewData.showEditPage ? Visibility.Visible : Visibility.Hidden)
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }

  private updateSubpageHeight(): boolean {
    if (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter) {
      return false;
    }
    let contentHeight = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.headerHeight +
    this.getTopTogglesHeight() + this.toggleAreaHeight;
    if (this.isIotServiceAlive) {
      contentHeight += this.iotHeight;
    }
    this.subpageHeight = Math.min(contentHeight,
      (this.listHeight - (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset as number ?? 0)) -
      ResUtils.getNumber($r('app.float.status_bar_phone_height')))
    return true;
  }

  @Builder
  loadIOTSubPageLayout() {
    if (this.updateSubpageHeight()) {
    }
    IOTSubPageLayout({
      isIotServiceAlive: this.isIotServiceAlive,
      contentHeight: this.subpageHeight,
    })
      .zIndex(1)
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }

  @Builder
  loadPrivacySubPageLayout() {
    if (this.updateSubpageHeight()) {
    }
    PrivacySubPageLayout({ contentHeight: this.subpageHeight })
      .zIndex(1)
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }

  @Builder
  loadMultimediaSubPageLayout() {
    if (this.updateSubpageHeight()) {
    }
    MultimediaSubPageLayout({ contentHeight: this.subpageHeight })
      .zIndex(1)
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }

  @Builder
  loadMediaCenterLayout() {
    MediaPlaybackComponent().zIndex(1).id('mediaPlaybackComponent')
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }

  @Builder
  loadIOTMainPage(index: number) {
    IOTMainPage({
      animationData: this.animationDataArray[index],
      isIotServiceAlive: $isIotServiceAlive,
      iotHeight: $iotHeight,
      iotDeviceList: this.iotDeviceList,
      showIOt: $showIOt,
      changeExtProxy: (uiExtProxy?: UIExtensionProxy) => {
        this.homeViewModel.uiExtProxy = uiExtProxy;
      },
      updateIotDevice:(iotDeviceList:number[]) =>{
        this.iotDeviceList = iotDeviceList;
      }
    })
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
      .height(this.iotHeight + PADDING_HEIGHT)
      .padding({top: PADDING_HEIGHT})
      .visibility(VisibilityController.getIOTVisibility(
        this.backgroundOpacity.backgroundOpacity, this.desktopMode, this.lockStatus, this.CloudMode))
  }

  /**
   * 背板，接收左右两侧点击和上滑收起事件
   */
  @Builder
  loadClickAndSlideUpBackboard() {
    Column()
      .height('100%')
      .width('100%')
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          GestureGroup(GestureMode.Parallel,
            // 接收上滑手势
            PanGesture({ direction: PanDirection.Up, distance: DISTANCE_FOLD_DROPDOWN })
              .onActionStart(event => {
                log.showInfo('hide cc by slide up blank area');
                DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP);
                DropDownPanelManager.animToDismiss();
              }),
            // 屏蔽下滑方向的滑动手势
            PanGesture({ direction: PanDirection.Down })
          ),
          TapGesture()
            .onAction((event?: GestureEvent) => {
              log.showInfo('hide cc by tap blank area');
              DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
              DropDownPanelManager.animToDismiss();
            })
        )
      )
      .accessibilityLevel('no')
      .focusable(false)
  }

  /**
   * 底部上滑home手势
   */
  @Builder
  loadHomeGestureBackboard() {
    Stack() {
      // 绑定上滑收起的底部空白区域，该范围最小为36vp
      Column()
        .height(this.slideUpBlankAreaHeight)
        .width(this.slideUpBlankAreaWidth)
        .gesture(
          GestureGroup(GestureMode.Parallel,
            // 接收上滑手势
            PanGesture({ direction: PanDirection.Up, distance: DISTANCE_FOLD_DROPDOWN })
              .onActionStart(event => {
                log.showInfo('hide cc by slide up blank area');
                DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP);
                DropDownPanelManager.animToDismiss();
              }),
            // 屏蔽下滑方向的滑动手势
            PanGesture({ direction: PanDirection.Down })
          )
        )
        .accessibilityLevel('no')
      // 绑定点击收起的底部空白区域，该范围为除去控制中心内容的剩余区域，最小为0
      Column()
        .height(this.tapBlankAreaHeight)
        .width(this.tapBlankAreaWidth)
        .hitTestBehavior(HitTestMode.Transparent)
        .gesture(
          TapGesture()
            .onAction((event?: GestureEvent) => {
              log.showInfo('hide cc by tap blank area');
              DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
              DropDownPanelManager.animToDismiss();
            })
        )
        .accessibilityLevel('no')
    }
    .focusable(false)
    .height('100%')
    .width('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .alignContent(Alignment.BottomEnd)
    .accessibilityLevel('no')
  }

  onFoldStatusChange() {
  }

  // 空白区域受到快捷开关行数、IOT卡片区域高度变化的影响
  setBottomBlankAreaHeight() {
    log.showInfo('setBottomBlankAreaHeight' + this.contentHeight + ':' + this.toggleAreaHeight);
    if (this.desktopMode.desktopMode === DesktopModeEnum.EMERGENCY_MODE) {
      // 334为媒体卡片、一行开关高度、头部按钮之和
      this.slideUpBlankAreaHeight = this.contentHeight - 334;
      this.tapBlankAreaHeight = this.slideUpBlankAreaHeight;
      return;
    }
    // 有iot卡片的时候额外多出16的上边距
    let iotHeight = this.lockStatus === 1 ? 0 : this.iotHeight + (this.iotHeight === 0 ? 0 : 16);
    log.showInfo(`iotHeight : ${this.iotHeight}, now lockStatus : ${this.lockStatus}`);
    if (this.ccLayoutIndex != ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      this.tapBlankAreaHeight = this.contentHeight - this.getTopTogglesHeight() -
        this.toggleAreaHeight - iotHeight;
      log.showInfo('tapBlankAreaHeight' + this.tapBlankAreaHeight);
      if (this.isLargeFoldStyle) {
        // 72 = 36(控制中心右边距) + 36(控制中心与媒体卡片边距)
        this.tapBlankAreaWidth = CC_LAYOUT_CONFIGS[this.ccLayoutIndex].singleCardWidth as number + 72;
        this.slideUpBlankAreaWidth = CC_LAYOUT_CONFIGS[this.ccLayoutIndex].singleCardWidth as number + 72;
      } else {
        this.tapBlankAreaWidth = '100%';
        this.slideUpBlankAreaWidth = '100%';
      }
      this.slideUpBlankAreaHeight = Math.max(this.tapBlankAreaHeight, BOTTOM_HOT_AREA);
    } else {
      this.tapBlankAreaHeight = this.contentHeight - this.style.landscapeOffset -
        this.toggleAreaHeight - iotHeight;
      log.showInfo('tapBlankAreaHeight' + this.tapBlankAreaHeight);
      this.tapBlankAreaWidth = '50%';
      this.slideUpBlankAreaWidth = '100%';
      this.slideUpBlankAreaHeight = BOTTOM_HOT_AREA;
    }
  }

  getTopTogglesHeight(): number {
    // 媒体+亮度音量组合同属一行，行高已按 mediaAndWifiBlue 计算，不再为 combined 额外加行
    let topToggleRows: number = this.topToggleArray.length + (this.isLargeFoldStyle ? 0 : 1);
    log.showInfo('topToggleRows:' + topToggleRows);
    return topToggleRows * TOP_TOGGLE_ROW_HEIGHT;
  }

  /**
   * 隐私指示器
   */
  @Builder
  loadPrivacySensor() {
    PrivacySensor({ animationData: this.animationDataArray[INDEX_HEADER] })
      .visibility(VisibilityController.getHeadVisibility(
        this.data.state, this.backgroundOpacity.backgroundOpacity, this.desktopMode, this.CloudMode))
      .height(this.isAccessibilityMode ?
        this.privacySensorParentComponentHeight + this.privacySensorData.privacySensorHeight : 0)
      .scale(this.data.state === ControlCenterState.MAIN_LAYOUT ?
        { x: 1, y: 1, centerY: this.contentHeight * 0.5 + 'vp' } :
        { x: MAIN_PAGE_HIDE_SCALE, y: MAIN_PAGE_HIDE_SCALE, centerY: this.contentHeight * 0.5 + 'vp' })
      .zIndex(MAIN_LAYOUT_PRIVACY_SENSOR_ZINDEX)
      .focusable(this.data.state === ControlCenterState.MAIN_LAYOUT)
      .enabled(!this.isListMoving || this.isLandscape)
  }

  /**
   * 直板机横屏左侧卡片区域(单独绘制头部区域)
   */
  @Builder
  loadTopToggleList() {
    Stack() {
      List({ scroller: this.topToggleScroller, space: TOGGLE_SPACE }) {
        ForEach(this.contentIndexArr, (item: string, index: number) => {
          if (item.startsWith(TOP_TOGGLE_ROW_ITEM_NAME)) {
            this.loadEachItem(item);
          }
        }, (item: string, index: number) => item)
        // 底部空白间隔
        ListItem() {
        }.visibility(Visibility.Hidden)
      }
      .clip(new Rect({ width: 350, height: this.listHeight }).position({ x: -15, y: 0 }))
      .scrollBar(BarState.Off)
      .chainAnimation(this.openChain)
      .cachedCount(LIST_ITEM_LINES, true)
      .chainAnimationOptions({
        minSpace: 12,
        maxSpace: 32,
        edgeEffect: ChainEdgeEffect.STRETCH
      })
      .onScrollStart(() => {
        this.isTopListAtEnd = this.topToggleScroller.isAtEnd();
        log.showInfo(`topToggleList onScrollStart isTopListAtEnd: ${this.isTopListAtEnd}`);
      })
      .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
        this.isTopListScroll = true;
        if (scrollOffset > 0 && scrollState === ScrollState.Scroll && this.isTopListAtEnd) {
          if (DropDownPanelManager.isPanelDismissing()) {
            return;
          }
          log.showInfo(`slide up to close the panel`);
          DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP_WHEN_REACH_END);
          DropDownPanelManager.animToDismiss();
        } else {
          this.isTopListAtEnd = false;
        }
      })
      .onScrollStop(()=>{
        this.isTopListScroll = false;
        log.showInfo(`onScrollStop isTopListScroll ${this.isTopListScroll}`);
      })
      .enableScrollInteraction(this.viewData.blankLayoutWeight === 1)
      .alignListItem(this.isLargeFoldStyle ? ListItemAlign.End : ListItemAlign.Center)
      .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
      .enabled(!this.controlCenterAnimating)
      .height(this.listHeight)
      .id(TAG + '_MainTopList')

      // 绑定横屏下点击收起的底部空白区域，该范围为除去控制中心内容的剩余区域，最小为0
      Column()
        .height(this.getTopToggleListBlankHeight())
        .width("100%")
        .hitTestBehavior(HitTestMode.Transparent)
        .gesture(
          TapGesture()
            .onAction((event?: GestureEvent) => {
              log.showInfo('hide cc by tap blank area');
              DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
              DropDownPanelManager.animToDismiss();
            })
        )
        .accessibilityLevel('no')
    }
    .height(this.listHeight)
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.scrollWidth)
    .alignContent(Alignment.Bottom)
  }

  private getTopToggleListBlankHeight(): number {
    let blankHeight: number = this.listHeight - this.getTopTogglesHeight();
    log.showInfo(`getTopToggleListBlankHeight ${this.listHeight} blankHeight ${blankHeight}`)
    return blankHeight < 0 ? 0 : blankHeight;
  }

  @Builder
  mediaCardBlankArea() {
    // 点击空白处收起控制面板
    Column()
      .layoutWeight(1)
      .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.singleCardWidth)
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          GestureGroup(GestureMode.Parallel,
            // 只接收上滑手势，屏蔽其它方向的滑动手势
            PanGesture({ direction: PanDirection.Up, distance: DISTANCE_FOLD_DROPDOWN })
              .onActionStart(event => {
                DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP);
                DropDownPanelManager.animToDismiss();
              }),
            PanGesture({ direction: PanDirection.Down })
          ),
          TapGesture()
            .onAction((event?: GestureEvent) => {
              DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
              DropDownPanelManager.animToDismiss();
            })
        )
      )
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'yes')
      .focusable(false)
  }

  getHeaderLayoutScale(): ScaleOptions {
    if (this.data.state === ControlCenterState.MEDIA_CENTER) {
      TraceUtil.endTrace(DomainName.CC, 'SCALE_HEADER');
    }
    return this.data.state === ControlCenterState.MAIN_LAYOUT ?
      { x: 1, y: 1, centerY: this.contentHeight * 0.5 + 'vp' } :
      { x: MAIN_PAGE_HIDE_SCALE, y: MAIN_PAGE_HIDE_SCALE, centerY: this.contentHeight * 0.5 + 'vp' };
  }

  @Builder
  loadHeaderLayout() {
    Row() {
      // 控制中心头部区域
      HeaderLayout({
        animationData: this.animationDataArray[INDEX_HEADER],
        onToggleEditClick: () => {
          this.isListFocused = false;
          if (!CC_LAYOUT_CONFIGS[this.ccLayoutIndex].isShowHeaderLayout) {
            log.showWarn('current layout is not support edit');
            return;
          }
          this.homeViewModel.jumpToEditView();
        },
        showToast: this.showToast,
        toggleData: this.quickToggles,
      })
        .margin(CC_LAYOUT_CONFIGS[this.ccLayoutIndex].headerMargin)
        .scale(this.getHeaderLayoutScale())
        .visibility(VisibilityController.getHeadVisibility(
          this.data.state, this.backgroundOpacity.backgroundOpacity, this.desktopMode, this.CloudMode))
    }
    .direction(Direction.Ltr)
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex].headerWidth ?? '100%')
    .justifyContent(CC_LAYOUT_CONFIGS[this.ccLayoutIndex].headerWidth ? FlexAlign.Center : FlexAlign.End)
    .visibility(VisibilityController.getHeadLayoutVisibility(
      this.data.state, this.backgroundOpacity.backgroundOpacity, this.CloudMode))
    .onAppear(() => {
      this.uiContextRequestFocus('Ctrl.HeaderLayout_Image_edit_btn');
    })
    .onDisAppear(() => {
      if (this.isLandscape) {
        setTimeout(() => {
          this.uiContextRequestFocus('control_center_media_card_previous');
        }, 50);
      }
    })
    .margin(this.screenWidth && CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.mainPanelMargin)
    .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentStartOffset ?? 0)
    // Adapts to bottom-layer gesture event determination specifications.
    .gesture(GestureGroup(GestureMode.Exclusive,
      TapGesture().onAction((event?: GestureEvent): void => {
        if (!this.dropDownStatus.isTouchingStatusBar && !this.isTouching) {
          DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
          DropDownPanelManager.onTapAction(event);
        }
      }),
      PanGesture()
        .onActionStart((event?: GestureEvent): void => DropDownPanelManager.onPanActionStart(event))
        .onActionUpdate((event?: GestureEvent): void => DropDownPanelManager.onPanActionUpdate(event))
        .onActionEnd((event?: GestureEvent): void => DropDownPanelManager.onPanActionEnd(event as GestureEvent))))
    .accessibilityLevel('no')
    .focusable(this.data.state === ControlCenterState.MAIN_LAYOUT)
    .zIndex(MAIN_LAYOUT_HEADER_ZINDEX)
    .enabled(!this.isListMoving)
  }

  @Builder
  loadBrightLayout(index: number) {
    BrightLayout({
      animationData: this.animationDataArray[index + 1],
      isLongSliderButton: true
    })
      .opacity(this.viewData.superTerminalOpacity)
  }

  @Builder
  loadVolumeLayout(index: number) {
    VolumeLayout({
      animationData: this.animationDataArray[index + 1],
      isLongSliderButton: true
    })
      .opacity(this.viewData.superTerminalOpacity)
  }

  getMainPageOffset(): number {
    if (this.ccLayoutIndex != ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      return 0;
    }
    return (this.privacySensorData.isApplicationInterview ||
      this.privacySensorData.multimediaSensorTypeArray.includes(true)) ?
        this.style.landscapeOffsetWithPrivacy : this.style.landscapeOffset;
  }

  private needShowIotPage(item: string): boolean {
    if (!item.startsWith(IOT_ITEM_NAME)) {
      return false;
    }
    this.showIOt = this.isIotServiceAlive && this.isIotNeedShow && this.isAccountLogin;
    let needShowIotPage = this.showIOt || this.isIotLoadCache;
    log.showInfo(`needShowIotPage showIOt:${this.showIOt}, isIotLoadCache:${this.isIotLoadCache}, isIotNeedShow:${this.isIotNeedShow}`);
    return needShowIotPage;
  }

  iotAccountLogin(): void {
    let accountAbility:account_distributedAccount.DistributedAccountAbility = account_distributedAccount
      .getDistributedAccountAbility();
    try {
      accountAbility.getOsAccountDistributedInfo().then((info) => {
        if (info.name === 'ohosAnonymousName') {
          this.isAccountLogin = false;
          this.iotDeviceList = [];
          this.iotHeight = 0;
        } else {
          this.isAccountLogin = true;
        }
      }).catch((err: BusinessError) => {
        log.error(`get osAccountInfo fail: ${err}`);
      });

      CommonEventManager.createSubscriber({ 'events': ['common.event.HWID_LOGIN', 'common.event.HWID_LOGOUT'] },
        (error, commonEventSubscriber) => {
          if (error) {
            log.error('create commonEvent subscriber failed, error: ' + error?.message);
            return;
          }
          //订阅智慧生活登录/注销事件
          this.commonEventSubscriber = commonEventSubscriber;
          try {
            CommonEventManager.subscribe(this.commonEventSubscriber, (err, data) => {
              if (data?.event === 'common.event.HWID_LOGIN') {
                log.showInfo('iotLoginEvent');
                this.isAccountLogin = true;
              } else if (data?.event === 'common.event.HWID_LOGOUT') {
                log.showInfo('iotLogout');
                this.isAccountLogin = false;
                this.iotDeviceList = [];
                this.iotHeight = 0;
              } else {
                log.showInfo('otherEvent' + data?.event);
              }
            });
          } catch (e) {
            log.error('account login fail catch error', e);
          }
        });
    } catch (error) {
      log.error('login fail catch error', error);
    }
  }

  /**
   * 播控一镜到底
   * @param state
   */
  doTransitionOfMediaCenter(state: number) {
    // 打断动效（该缓存变量，用于判断退出动效是否执行完毕）
    if (AppStorage.get('mediaExitTransitionDone')) {
      return;
    }
    if (state !== ControlCenterState.MEDIA_CENTER) {
      AppStorage.setOrCreate('mediaExitTransitionDone', true);
    }
    // 动效开始（该缓存变量，用于延迟显示 非共享元素）
    AppStorage.setOrCreate('mediaTransitionDone', false);
    log.showInfo(`mediaControllerTrace start`);
    let flag = this.mediaTransitionLink.get();
    this.mediaTransitionLink.set(flag + 1);
    // 一镜到底弹簧动画
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    animateTo({
      curve: Curves.interpolatingSpring(0, 1, 228, this.isSmallFoldOuterScreen ? 23 : 25),
      onFinish: () => {
        log.showInfo(`mediaControllerTrace end`);
        AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
        // 性能打点
        performanceMonitor.end('INTO_CC_MEDIA_ANI');
        performanceMonitor.end('EXIT_CC_MEDIA_ANI');
        if (state !== ControlCenterState.MEDIA_CENTER) {
          AppStorage.setOrCreate('mediaExitTransitionDone', false);
        }
        let flag = this.mediaTransitionLink.get();
        this.mediaTransitionLink.set(flag - 1 < 0 ? 0 : flag - 1);
      }
    }, () => {
      AppStorage.setOrCreate('ControlCenterState', state);
    })
    // 延迟动效，淡入淡出
    setTimeout(() => {
      AppStorage.setOrCreate('mediaTransitionDone', true);
    }, 300)
    this.mainLayoutHideAnim(state);
  }

  /**
   * 亮度条、音量条一镜到底
   * @param state
   */
  doTransitionOfSliderButton(state: number) {
    // 一镜到底弹簧动画
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    animateTo({
      curve: Curves.springMotion(0.34, 0.82),
      onFinish: () => {
        AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
        performanceMonitor.end('INTO_CC_SUB_BRIGHTNESS_ANI');
        performanceMonitor.end('INTO_CC_SUB_VOLUME_ANI');
        performanceMonitor.end('EXIT_CC_SUB_BRIGHTNESS_ANI');
        performanceMonitor.end('EXIT_CC_SUB_VOLUME_ANI');
      }
    }, () => {
      AppStorage.setOrCreate('ControlCenterState', state);
    })
    this.mainLayoutHideAnim(state);
  }

  doGeometryTransitionOfSubpage(state: number) {
    // 一镜到底弹簧动画
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    if (state === ControlCenterState.MAIN_LAYOUT) {
      log.showInfo('start change subpage opacity');
      animateTo({
        delay: 180,
        duration: 320,
        curve: Curve.Friction
      }, () => {
        this.subpageOpacity = 0;
      });
    }

    animateTo({
      curve: Curves.springMotion(0.42, 0.85),
      onFinish: () => {
        AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
        performanceMonitor.end('INTO_CC_SUB_WIFI_ANI');
        performanceMonitor.end('INTO_CC_SUB_BLUETOOTH_ANI');
        performanceMonitor.end('EXIT_CC_SUB_WIFI_ANI');
        performanceMonitor.end('EXIT_CC_SUB_BLUETOOTH_ANI');
        log.showInfo(`onDataChange, show subpage anim finish, springCurve.`);
      }
    }, () => {
      AppStorage.setOrCreate('ControlCenterState', state);
      log.showInfo(`onDataChange, animateTo subpage, springCurve`);
    });
    this.mainLayoutHideAnim(state);
  }

  private mainLayoutHideAnim(state: number) {
    if (state !== ControlCenterState.MAIN_LAYOUT) {
      // 主布局淡出动画
      animateTo({
        curve: Curve.Friction,
        duration: 100
      }, () => {
        this.data.state = state;
      });
      // 通过animateTo而不是setTimeout的方式确保模糊消失一定在主布局淡出之后执行
      animateTo({
        delay: 80,
        curve: Curve.Friction,
        duration: 5
      }, () => {
        this.scrollBlurController?.inactiveScrollerBlur();
        this.scrollBlurController?.disableScrollBlur();
      });
    } else {
      setTimeout(() => {
        if (state === ControlCenterState.MAIN_LAYOUT) {
          try {
            if (this.ccLayoutIndex !== ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
              this.scrollBlurController?.enableScrollBlur();
            }
            if (!this.homeViewModel.getIsEditing()) {
              this.scrollBlurController?.onListScrollWithBlur();
            }
          } catch (error) {
            log.showError(`scrollBlurController error`);
          }
        }
      }, 180);
      // 主布局显示动画
      animateTo({
        delay: 160,
        curve: curves.cubicBezierCurve(0.42, 0.00, 0.44, 1.00),
        duration: 200
      }, () => {
        this.data.state = state;
      });
    }
  }

  doGeometryTransitionOfSoundSubPage(state: number) {
    animateTo({
      curve: Curves.springMotion(0.34, 0.82),
      onFinish: () => {
        log.showInfo(`onDataChange, show SoundSubPage anim finish.`);
      }
    }, () => {
      AppStorage.setOrCreate('ControlCenterState', state);
      log.showInfo(`onDataChange, animateTo SoundSubPage`);
    });
    this.mainLayoutHideAnim(state);
  }

  /**
   * 控制中心状态切换回调
   *
   * @param state 新状态值
   */
  onControlCenterStateChanged(state: ControlCenterState): void {
    Controller.shieldVolumePanelCheck(state);
    if (this.data.state == state) {
      return;
    }
    log.showInfo(`onControlCenterStateChanged, new state: ${state}.`);
    let isSubPage: boolean =
      (this.data.state == ControlCenterState.SUB_PANEL && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.SUB_PANEL);
    let isIotSubPage: boolean =
      (this.data.state == ControlCenterState.IOT_SUB_PAGE && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.IOT_SUB_PAGE);
    let isPrivacySubPage: boolean =
      (this.data.state == ControlCenterState.PRIVACY_SUB_PAGE && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.PRIVACY_SUB_PAGE);
    let isMultimediaSubPage: boolean =
      (this.data.state == ControlCenterState.MULTIMEDIA_SUB_PAGE && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.MULTIMEDIA_SUB_PAGE);
    let isMediaCenter: boolean =
      (this.data.state == ControlCenterState.MEDIA_CENTER && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.MEDIA_CENTER);
    let isSoundSubPage: boolean =
      (this.data.state == ControlCenterState.SOUND_SUB_PAGE && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.SOUND_SUB_PAGE);
    let isBrightnessSubPage: boolean =
      (this.data.state == ControlCenterState.BRIGHTNESS_SUBPAGE && state == ControlCenterState.MAIN_LAYOUT) ||
        (this.data.state == ControlCenterState.MAIN_LAYOUT && state == ControlCenterState.BRIGHTNESS_SUBPAGE);

    let isQuitEdit = (this.data.state === ControlCenterState.TOGGLE_EDIT && state === ControlCenterState.MAIN_LAYOUT);
    if (isQuitEdit) {
      this.homeViewModel.afterQuitEdit();
    }
    this.isEditMode = state === ControlCenterState.TOGGLE_EDIT;
    if (state === ControlCenterState.MAIN_LAYOUT) {
      PrivacySensorViewModel.getInstance().initData();
    } else {
      this.animationDataArray[INDEX_HEADER].translate = 0;
      this.isListMoving = false;
      this.isTopListScroll = false;
    }
    // 播放无障碍提示
    this.sendSubPageAccessibilityText(this.data.state, state);
    // 走焦
    this.requestFocus(this.data.state, state);
    // 打开二级界面的时候，主布局隐藏需要通过动画过渡
    let needHideWithAnim = isSubPage || isIotSubPage || isMediaCenter || isPrivacySubPage || isMultimediaSubPage ||
      isSoundSubPage || isBrightnessSubPage;
    log.showInfo(`onControlCenterStateChanged, needAnim:${needHideWithAnim}, new state:${state}, old state:${this.data.state}`);
    if (!needHideWithAnim) {
      Controller.setControlCenterState(state);
      return;
    }
    this.onStateChangedCancelTouch(state);
    // 普通二级页面需要一镜到底动效
    if (isSubPage || isMultimediaSubPage) {
      this.doGeometryTransitionOfSubpage(state);
      return;
    }
    // 播控中心一镜到底
    if (isMediaCenter) {
      this.doTransitionOfMediaCenter(state);
      return;
    }
    // 亮度条、音量条一镜到底
    if (isBrightnessSubPage || isSoundSubPage) {
      this.doTransitionOfSliderButton(state);
      return;
    }
    // 二级页状态兜底（从二级页切换到IOT/编辑页，导致二级页状态异常）
    if (this.data.state === ControlCenterState.SUB_PANEL && state !== ControlCenterState.SUB_PANEL) {
      log.showInfo(`onControlCenterStateChanged, reset showingSlot`);
      sToggleSubWindowController.setShowingSlot('');
    }
    // 隐私、IOT二级页面的展开收起动效
    this.doTransitionOfSubpage(state);
  }

  private doTransitionOfSubpage(state: ControlCenterState) {
    animateTo({
      curve: Curve.Friction,
      duration: 400,
      onFinish: () => {
        log.showInfo(`onDataChange, show subpage anim finish, Friction.`);
      }
    }, () => {
      AppStorage.setOrCreate('ControlCenterState', state);
      log.showInfo(`onDataChange, animateTo subpage, Friction`);
    });
    this.mainLayoutHideAnim(state);
  }

  onStateChangedCancelTouch(state: ControlCenterState): void {
    if (state === ControlCenterState.IOT_SUB_PAGE || state === ControlCenterState.SUB_PANEL ||
      state === ControlCenterState.SOUND_SUB_PAGE) {
      log.showInfo(`onStateChangedCancelTouch, new state:${state}, start onTouchCancel`);
      this.onTouchCancel(undefined);
    }
  }

  /**
   * list滑动监听，用于面板收起逻辑
   *
   * @param event TouchEvent
   */
  // 处理回弹动效和上滑收起事件的策略
  // 1、当列表触顶的时候，继续向下滑动，触发跟手动效，跟手位移根据手指每次相对上一次触摸点的滑动距离计算的
  // 2、当列表触底的时候，再次向上滑动才收起列表，计算的是手指向上滑动的距离
  // 3、当列表既不触顶也不触底的时候，不额外处理任何touch事件
  onListTouchEvent(event: TouchEvent) {
    // 如果状态栏下拉手势还未结束或者当前窗口未显示，新手势不起作用
    if (this.dropDownStatus.isTouchingStatusBar) {
      log.showInfo(`hand gesture conflict, isTouchingStatusBar:${this.dropDownStatus.isTouchingStatusBar}`);
      return;
    }
    if (SliderButtonShareData.getInstance()?.isDragging && (event.type === TouchType.Down ||
      event.type === TouchType.Move)) {
      log.showInfo('slider is dragging, not deal touch event ' + event.type);
      return;
    }
    // 如果前一个触控手势还未结束，新手势不起作用
    let changedTouchId = event.changedTouches[0].id;
    if (this.currentTouchId != DEFAULT_TOUCH_ID && changedTouchId != this.currentTouchId) {
      log.showInfo(`hand gesture conflict: ${event.changedTouches[0].id} currentTouchId:${this.currentTouchId}`);
      return;
    } else if (this.currentTouchId != changedTouchId) {
      this.currentTouchNo = (this.currentTouchNo + 1) % TOUCH_NUM_MAX;
    }
    this.currentTouchId = changedTouchId;
    switch (event.type as TouchType) {
      case TouchType.Down:
        this.onTouchDown(event)
        break;
      case TouchType.Move:
        this.isListMoving = true;
        if (this.startY === -1) {
          log.showInfo('startY is not init, no need deal with');
          return;
        }

        // 不处理横滑事件
        let diffX = event.changedTouches[0].x - this.startX;
        let diffY = Math.abs(event.changedTouches[0].y - this.startY);
        if (DropDownPanelManager.getDropDirection(diffX, diffY) != TargetChangeState.VERTICAL) {
          log.showDebug(`direction is not vertical or below min distance, return`);
          break;
        }

        let newY = event.changedTouches[0].y;
        this.relativeDistance = newY - this.startY;
        DropDownPanelManager.updateMoveDown(this.relativeDistance);
        log.showDebug(`onTouchEvent Move-- newY: ${event.touches[0].y} startY:${this.startY}, isAtEnd: ${this.scroller.isAtEnd()}`);
        if (this.relativeDistance > 0) {
          this.hasScrollDown = true;
        }
        // 当列表触底后，再次向上滑动时，达到阈值需要收起面板，计算向上位移是否达到收起面板阈值
        if (this.needClosePanel()) {
          log.showDebug(`slide up to close the panel, startY is ${this.startY}, endY is ${this.relativeDistance}`);
          if (DropDownPanelManager.isPanelDismissing()) {
            return;
          }
          DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP_WHEN_REACH_END);
          DropDownPanelManager.animToDismiss();
          if (event.stopPropagation) {
            AppStorageUtil.setOrCreate('isInStatusBarGesture', false, new DataProperty(false, false));
            event.stopPropagation();
          }
          break;
        }
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.isListMoving = false;
        this.onTouchCancel(event)
        break;
    }
  }

  /**
   * 上滑是否达到执行收起面板逻辑
   * @returns
   */
  private needClosePanel(): boolean {
    if (this.hasScrollDown || this.lastTouchNo !== this.currentTouchNo) {
      return false;
    }
    if (this.startY <= 0 || this.relativeDistance >= DropDownPanelManager.getFoldDropDownSlop()) {
      return false;
    }
    // 判断横屏下是否左侧列表在滚动，如果在滚动就不收起
    if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE && this.isTopListScroll) {
      return false;
    }
    return this.startWhenListReachBottom;
  }

  onTouchDown(event: TouchEvent) {
    log.showInfo(`onTouchEvent Down, reach top: ${this.listController.isReachTop}, isAtEnd: ${this.scroller.isAtEnd()}`);
    this.isTouching = true;
    this.lastTouchNo = this.currentTouchNo;
    this.translateY = 0;
    this.hasScrollDown = false;
    DropDownPanelManager.clearDropDirection();
    this.startY = event.changedTouches[0].y;
    this.startX = event.changedTouches[0].x;
    this.lastY = this.startY;
    this.startWhenListReachTop = this.listController.isReachTop;
    this.startWhenListReachBottom = this.scroller.isAtEnd();
    log.showDebug(`set startY to ${this.startY}, set startX to ${this.startX}`);
    // 开始每帧回调
    this.displaySyncObject?.start();
  }

  onTouchCancel(event?: TouchEvent) {
    this.isTouching = false;
    this.currentTouchId = DEFAULT_TOUCH_ID;
    this.startY = -1;
    this.translateY = 0;
    if (event) {
      log.showDebug(`onTouchEvent up-- upY: ${event?.changedTouches[0].y}`);
    }
    DropDownPanelManager.endMoveDown();
    // 停止每帧回调
    this.displaySyncObject?.stop();
  }

  private getAnimArraySize(): number {
    if (this.contentIndexArr.includes(IOT_ITEM_NAME)) {
      // 下拉收起动效的行数包含头部区域，所以需要+1
      return this.contentIndexArr.length + 1 - (this.showIOt ? 0 : 1);
    } else {
      return this.contentIndexArr.length + 1;
    }
  }

  setContentTranslateY(newValue: number, isStretch?: boolean) {
    for (let i = 0; i < this.getAnimArraySize(); i++) {
      // 过界保护
      if (i > this.animationDataArray.length - 1) {
        return;
      }
      if (isStretch) {
        this.animationDataArray[i].translate = newValue + newValue * 0.05 * i;
      } else {
        this.animationDataArray[i].translate = newValue + newValue * 0.02 * i;
      }
    }
  }

  /**
   * 横竖屏切换回调
   */
  onOrientationChanged() {
    // 用于打点
    DropDownPanelManager.onOrientationChanged(this.isLandscape);
    if (!this.isLandscape) {
      setTimeout(() => {
        this.scrollBlurController?.setScrollToIndex();
        this.topToggleScroller.scrollToIndex(0);
        this.animationDataArray[INDEX_HEADER].translate = 0;
        this.isListMoving = false;
        this.isTopListScroll = false;
      }, 1)
    }
  }

  /**
   * 下拉事件参数改变回调
   */
  async onDropdownChanged() {
    this.setVisible(this.dropDownEvent);
    // 非控制中心，不处理
    if (this.dropDownEventState.target != TargetPanel.CONTROL_CENTER_PANEL) {
      log.showDebug('back to main page');
      let currentState: ControlCenterState = this.data.state;
      this.onControlCenterStateChanged(ControlCenterState.MAIN_LAYOUT);
      if (currentState === ControlCenterState.SUB_PANEL) {
        sToggleSubWindowController.hideWindow();
      } else if (this.isEditMode || currentState === ControlCenterState.TOGGLE_EDIT) {
        this.isEditMode = false;
        this.homeViewModel.hideEditPanelDirectly();
      }
      // 下拉进入通知中心会走进该分支，初始化控制中心布局。因为左滑能直接切换到控制中心，需要提前加载好
      if (this.dropDownEventState.target === TargetPanel.NOTIFICATION_PANEL &&
        this.lastPanelType === TargetPanel.NONE) {
        this.setContentTranslateY(0);
        this.scrollBlurController?.setScrollToIndex();
        this.topToggleScroller.scrollToIndex(0);
        this.showControlCenterDirectly(true);
      }
      // 收起通知中心会走进该分支，隐藏控制中心布局
      if (this.dropDownEventState.target === TargetPanel.NONE &&
        this.lastPanelType === TargetPanel.NOTIFICATION_PANEL) {
        this.showControlCenterDirectly(false);
      }
      // 切换到通知中心，复位
      if (this.lastPanelType === TargetPanel.CONTROL_CENTER_PANEL) {
        this.scrollBlurController?.setScrollToIndex();
        this.topToggleScroller.scrollToIndex(0);
      }
      this.lastPanelType = this.dropDownEventState.target;
      AppStorage.setOrCreate('isToggleLightEnabled', false);
      return;
    }
    // 需要显示下拉面板时初始化亮度值
    if (this.lastPanelType !== TargetPanel.CONTROL_CENTER_PANEL &&
      this.dropDownEventState.target === TargetPanel.CONTROL_CENTER_PANEL) {
      Controller.updateUIFromCache();
    }
    log.showDebug(`onDropdownChanged, dropDownEvent: ${this.dropDownEventState.target}--${this.dropDownEventState.progress}--${this.dropDownEventState.translateY}, progress: ${this.progress}, translateY: ${this.translateY}`);
    // 到达展开阈值，卡片执行opacity动画
    if ((this.progress < 1 && this.dropDownEventState.progress == 1 &&
      this.dropDownEventState.targetChanged != TargetChangeState.HORIZONTAL) ||
        (this.progress === 1 && this.lastPanelType === TargetPanel.NONE)) {
      // 每次下拉回到列表顶部
      this.scrollBlurController?.setScrollToIndex();
      this.topToggleScroller.scrollToIndex(0);
      this.setContentTranslateY(0);
      this.startControlCenterAnim(true);
      this.isListMoving = false;
      this.isTopListScroll = false;

      // 防止下次回调慢不能及时改变列表触底状态
      this.listController.isReachTop = true;
      this.currentTouchId = DEFAULT_TOUCH_ID;
    }
    if (this.progress == 1) {
      // 到达收起阈值，卡片执行opacity动画
      if (this.dropDownEventState.progress < 1) {
        await this.startControlCenterAnim(false);
      }
      if (this.dropDownEventState.translateY >= 0) {
        if (this.translateY > 0 && this.dropDownEventState.translateY == 0) {
          let itemSize: number = this.getAnimArraySize();
          this.animationViewModel.touchEndCheckAnim(this.progress, itemSize,
            DropDownPanelManager.isStartFromPanelStatusBar() ? false : true);
          DropDownPanelManager.setStartFromPanelStatusBar(false);
        }
        this.translateY = this.dropDownEventState.translateY;
        if (this.translateY > 0) {
          // 当列表在触顶状态的时候下拉才跟手，不在触顶状态不处理跟手动效
          if (!this.listController.isReachTop) {
            log.showDebug(`only move when list reach top`);
            return;
          }
          this.setContentTranslateY(this.translateY * this.transYCoefficient,
            DropDownPanelManager.isStartFromPanelStatusBar() ? false : true);
        }
      }
    }
    this.progress = this.dropDownEventState.progress;
    this.lastPanelType = this.dropDownEventState.target;
  }

  // 根据下拉事件的属性设置可见状态
  private setVisible(dropDownEvent: DropDownEvent): void {
    let isShowPanelContent: boolean = dropDownEvent.targetChanged == TargetChangeState.HORIZONTAL ||
      dropDownEvent.targetChanged == TargetChangeState.HORIZONTAL_UP_BACK ||
      dropDownEvent.targetChanged == TargetChangeState.VERTICAL_FLING;
    Controller.setControlCenterVisible(dropDownEvent.target == TargetPanel.CONTROL_CENTER_PANEL ||
      isShowPanelContent);
    Controller.shieldVolumePanelCheck();
  }

  public showControlCenterDirectly(isIotLoadCache: boolean): void {
    log.showInfo(`controlCenterEnterDirectly start, is show is ${isIotLoadCache}`);
    this.isHideAnimStarted = false;
    this.setIotCardVisibility(false, isIotLoadCache);
    if (isIotLoadCache) {
      this.shouldClip = false;
    } else {
      this.progress = 0;
    }
    this.dropDownEvent.pullFraction = 1;

    // Control Center Initialization
    this.animationViewModel.resetData(isIotLoadCache);
  }

  /**
   * 卡片透明度变化动画
   *
   * @param isShow 面板显示or隐藏
   */
  public async startControlCenterAnim(isShow: boolean): Promise<void> {
    log.showInfo(`startControlCenterAnim start, isShow: ${isShow}`);
    if (isShow) {
      this.showControlCenterAnim();
    } else {
      await this.hideControlCenterAnim();
    }
  }

  private showControlCenterAnim(): void {
    log.showInfo('IntoCC start');
    // 兜底处理拖动亮度条被异常打断，控制中心透明度没有恢复为1的情况
    if (this.backgroundOpacity.backgroundOpacity === 0) {
      log.showInfo('recover mainLayout opacity');
      BrightnessSharedViewData.getInstance().reset();
    }
    this.viewData.resetParam();
    this.listController.isReachTop = true;
    this.openChain = true;
    this.shouldClip = false;
    this.isHideAnimStarted = false;
    PrivacySensorViewModel.getInstance().initData();
    this.setIotCardVisibility(true, true);
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
    performanceMonitor.begin('INTO_CC_ANI', performanceMonitor.ActionType.FIRST_MOVE);
    let requestEvent = PluginCardChangeEvent.getInstance(PluginCardChangeEvent.PLUGIN_CARD_SHOW);
    EvtBus.post(PluginCardChangeEvent, requestEvent);

    let totalDelay = 0;
    for (let i = 0; i < this.animationDataArray.length; i++) {
      // Shape animate
      animateToImmediately({
        duration: ControlCenterAnim.APPEAR_DURATION,
        curve: Curve.Friction,
        delay: totalDelay,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => this.handleAnimationFinish()
      }, () => {
        this.animationCount++;
        this.animationDataArray[i].opacity = 1.0;
        this.animationDataArray[i].scale = 1.0;
      });
      // Translate animate
      animateToImmediately({
        duration: ControlCenterAnim.APPEAR_DURATION,
        curve: Curves.interpolatingSpring(0, 1, 228, 30),
        delay: 0,
        iterations: 1,
        playMode: PlayMode.Normal,
        onFinish: () => this.handleAnimationFinish()
      }, () => {
        this.animationCount++;
        this.animationDataArray[i].itemTranslate = 0;
      });
      this.changeLabelColor(i);
      totalDelay += ANI_DELAY;
    }
  }

  /**
   * 在第一行开关出现动画前改变文字颜色
   * 根据取色接口获取壁纸类型来改变文字颜色：
   * 1、type1 or type2: 浅色壁纸 文字颜色：60% 黑色
   * 2、type4：极深壁纸 文字颜色：50% 白色
   * 3、其他：普通花壁纸等 文字颜色：70% 白色
   * @param index
   */
  private changeLabelColor(index: number): void {
    if (index === ROW_COUNT_OF_HEADER) {
      let type: number = (new Int32Array(Controller.backgroundType))[0];
      if (type === Controller.getLastBackgroundType()) {
        return;
      }
      Controller.setLastBackgroundType(type);
      log.showInfo('start change label color type:' + type);
      ColorInvertTool.getInstance().changeLabelColor(type);
    }
  }

  private async hideControlCenterAnim(): Promise<void> {
    if (!(await ViewManagerAdapter.isViewShowing(ViewType.DROPDOWN))) {
      log.showInfo('window already hide');
      this.animationViewModel.resetData(false);
      this.setIotCardVisibility(false, false);
      return;
    }
    if (this.progress === 0) {
      log.showInfo('no need to do hide anim when already hide');
      return;
    }
    log.showInfo('ExitCC start');
    EvtBus.post(ControlCenterAnimatingEvent, { controlCenterAnimating: true });
    if (this.listController.isReachTop) {
      this.shouldClip = false;
    }
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
    this.isHideAnimStarted = true;
    setTimeout(() => {
      this.scrollBlurController?.inactiveScrollerBlur();
    }, 180);
    animateTo({
      duration: ControlCenterAnim.DISAPPEAR_DURATION,
      curve: Curve.Friction,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish: () => {
        // IotCard invisible after finish, avoid iot card dismiss cause height animation.
        this.setIotCardVisibility(false, false);
        this.handleAnimationFinish();
      }
    }, () => {
      this.animationCount++;
      this.animationViewModel.resetData(false);
    });
  }

  private handleAnimationFinish(): void {
    this.animationCount--;
    if (this.animationCount == 0) {
      // 如果有资源的释放需要重新加载
      this.trimMemory = false;
      log.showInfo('IntoCC/ExitCC end ; All Control Center animation finish, mark renderGroup false.');
      this.dropDownEvent.pullFraction = 1;
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
      Trace.end(Trace.CORE_METHOD_START_DROP_DOWN_PANEL);
      performanceMonitor.end('INTO_CC_ANI');
      performanceMonitor.end('EXIT_CC_ANI');
    }
  }

  private setIotCardVisibility(isShow: boolean, isIotLoadCache: boolean): void {
    log.showDebug(`set iot visibility:${isShow},login:${this.isAccountLogin},delay:${Controller.isDelayReleaseIot()}`);
    clearTimeout(this.releaseIotTimeout);
    if (!isShow) {
      this.releaseIotTimeout = setTimeout(() => {
        log.showInfo('release iot with delay');
        Controller.setDelayReleaseIot(false);
        this.isIotNeedShow = false;
        this.isIotServiceAlive = false;
        this.isIotLoadCache = false;
        clearTimeout(this.releaseIotTimeout);
      }, IOT_TIMEOUT);
      return;
    }
    this.isIotLoadCache = isIotLoadCache;
    this.isIotNeedShow = isShow;
    this.isIotServiceAlive = isShow;
  }

  private onIotServiceStateChange(): void {
    if (this.isIotServiceAlive || !this.isIotNeedShow) {
      return;
    }

    log.showWarn('iot service died');
    setTimeout(() => {
      log.showInfo('reload iot service');
      this.isIotServiceAlive = true;
    }, 1000)
  }

  private iotCacheUpdateEvent(): void {
    // 监听手机控制中心横滑
    this.eventMgr.on(PluginCardChangeEvent, (event: PluginCardChangeEvent) => {
      if (event.status === PluginCardChangeEvent.PLUGIN_CARD_SHOW) {
        log.showInfo('PluginCardChangeEvent callback:' + this.showIOt);
        this.setIotCardVisibility(true, true);
      }
    });
  }

  private sendSubPageAccessibilityText(curState: ControlCenterState, nextState: ControlCenterState): void {
    if (curState === nextState || !this.isAccessibilityMode) {
      return;
    }
    this.sendSubPageAccessibilityTextOfSlider(curState, nextState);
    // 二级页面播报 : 普通二级页
    if (curState === ControlCenterState.MAIN_LAYOUT && nextState === ControlCenterState.SUB_PANEL) {
      if (sToggleSubWindowController.getCurrentClickInfo()?.abilityName === undefined) {
        AccessibilityUtil.requestFocusAccessibility(sToggleSubWindowController.getCurrentSubPanelSlot() + '_title');
      }
    } else if (curState === ControlCenterState.SUB_PANEL && nextState === ControlCenterState.MAIN_LAYOUT) {
      let subPanelSlot = sToggleSubWindowController.getCurrentSubPanelSlot();
      setTimeout(async () => {
        if (!(await ViewManagerAdapter.isViewShowing(ViewType.DROPDOWN))) {
          return;
        }
        AccessibilityUtil.requestFocusAccessibility('transition_toggle' + subPanelSlot);
      }, REQUEST_FOCUS_DELAY);
    }
    // 编辑页面播报
    if (curState === ControlCenterState.MAIN_LAYOUT && nextState === ControlCenterState.TOGGLE_EDIT) {
      AccessibilityUtil.requestFocusAccessibility('Ctrl.ToggleEditView_header_btn_left_FOCUS');
    } else if (curState === ControlCenterState.TOGGLE_EDIT && nextState === ControlCenterState.MAIN_LAYOUT) {
      AccessibilityUtil.requestFocusAccessibility('Ctrl.HeaderLayout_Image_edit_button');
    }
  }

  private sendSubPageAccessibilityTextOfSlider(curState: ControlCenterState, nextState: ControlCenterState): void {
    // 二级页面播报 : 亮度
    if (curState === ControlCenterState.MAIN_LAYOUT && nextState === ControlCenterState.BRIGHTNESS_SUBPAGE) {
      AccessibilityUtil.requestFocusAccessibility('subpage_element_text');
    } else if (curState === ControlCenterState.BRIGHTNESS_SUBPAGE && nextState === ControlCenterState.MAIN_LAYOUT) {
      let brightTag: string = sBrightnessSubPageLayoutController.isHorizontal() ? '' : '_isVertical';
      AccessibilityUtil.requestFocusAccessibility('slider_layer_access_brightness' + brightTag);
    }
    // 二级页面播报 : 声音
    if (curState === ControlCenterState.MAIN_LAYOUT && nextState === ControlCenterState.SOUND_SUB_PAGE) {
      AccessibilityUtil.requestFocusAccessibility('subpage_element_text');
    } else if (curState === ControlCenterState.SOUND_SUB_PAGE && nextState === ControlCenterState.MAIN_LAYOUT) {
      let soundTag: string = soundSubPageController.isHorizontal() ? '' : '_isVertical';
      AccessibilityUtil.requestFocusAccessibility('slider_layer_access_volume' + soundTag);
    }
  }

  requestFocus(curState: ControlCenterState, nextState: ControlCenterState): void {
    // 编辑页面退出聚焦
    if (curState === ControlCenterState.TOGGLE_EDIT && nextState === ControlCenterState.MAIN_LAYOUT) {
      setTimeout(() => {
        this.uiContextRequestFocus('Ctrl.HeaderLayout_Image_edit_btn');
      }, 50)
    } else if (curState === ControlCenterState.SUB_PANEL && nextState === ControlCenterState.MAIN_LAYOUT) {
      let subPanelSlot = sToggleSubWindowController.getCurrentSubPanelSlot();
      setTimeout(() => {
        this.uiContextRequestFocus('Ctrl.NewToggleBaseComponent_Text_' + subPanelSlot);
      }, 50)
    } else if (curState === ControlCenterState.SOUND_SUB_PAGE && nextState === ControlCenterState.MAIN_LAYOUT) {
      setTimeout(() => {
        this.uiContextRequestFocus('slider_layer_volume');
      }, 50)
    } else if (curState === ControlCenterState.BRIGHTNESS_SUBPAGE && nextState === ControlCenterState.MAIN_LAYOUT) {
      setTimeout(() => {
        this.uiContextRequestFocus('slider_layer_brightness');
      }, 50)
    }
  }

  uiContextRequestFocus(id: string): void {
    try {
      this.getUIContext().getFocusController().requestFocus(id);
    } catch (error) {
      log.showInfo(`requestFocus error: ${error}`);
    }
  }

  updateListHeight() {
    log.showInfo(`updateListHeight screenHeight=${this.screenHeight}, curListHeight=${this.listHeight}`);
    this.listHeight = this.screenHeight - this.getMainPageOffset() +
      (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset as number ?? 0);
  }

  private isAccessibilityModeEnable(): boolean | undefined {
    if (ThreadUtil.isMainThread) {
      return this.isAccessibilityMode;
    } else {
      return AccessibilityVm.instance.isEnabled;
    }
  }
}
