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
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import { LogDomain, LogHelper, DataProperty, AppStorageUtil, RectInfo } from '@ohos/basicutils';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { TargetPanel, sEventManager } from '@ohos/frameworkwrapper';
import
  Constants,
  { ControlCenterData, SUBPAGE_LONG_SPRING_DURATION } from '../../common/Constants';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, { ControlCenterComponentStyle } from '../../common/StyleConfiguration';
import MediaPlaybackComponent from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/MediaPlaybackComponent';
import MediaCardLayout from './SingleFoldControlCenterMediaCardLayout';
import { SubPageLayout } from '../newStyle/SubPageLayout';
import Controller from '../../controller/ControlCenterController';
import { BrightnessSharedViewData } from '../../viewModel/BrightnessViewModel';
import { BackgroundOpacity } from '../../model/BrightnessViewData';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { LauncherAbilityManagerAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/LauncherAbilityManagerAdapter';
import {
  CC_LAYOUT_CONFIGS,
  ControlCenterLayoutController,
  ControlCenterLayoutIndex
} from '../../controller/SingleFoldControlCenterLayoutController';
import displaySync from '@ohos.graphics.displaySync';
import type { ExpectedFrameRateRange } from 'ExpectedFrameRateRange';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { ControlCenterHomeViewData } from '../../vm/ControlCenterHomeViewData';
import { ControlCenterHomeViewModel } from '../../vm/ControlCenterHomeViewModel';
import { ControlCenterAnimationViewModel } from '../../viewModel/ControlCenterAnimationViewModel';
import { DesktopMode, EmergencyManager, EMERGENCY_TOGGLES } from '../../viewModel/EmergencyManager';
import QuickToggleRow from './SingleFoldQuickToggleRow';
import { AddMoreToggleButton } from '../../view/AddMoreToggleButton';

import VisibilityController from '../../controller/ControlCenterVisibilityController'
import { ControlCenterPanelDropdownEvent } from '../../model/ControlCenterPanelDropdownEvent';
import Prompt from '@ohos.promptAction';
import { ScrollBlurViewData } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurViewData';
import { VolumeController } from '@ohos/soundcomponent/src/main/ets/controller/VolumnController';
import VolumeAndBrightLayout from '../newStyle/VolumeAndBrightLayout';

import { ControlCenterViewData } from '../../vm/ControlCenterViewData';
import { ControlCenterViewModel } from '../../viewModel/ControlCenterViewModel';
import { FASlotName } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { ToggleComponent } from '@ohos/controlcentercommon/src/main/ets/toggle/view/NewToggleBaseComponent';
import { QuickToggleController } from '../../controller/QuickToggleController';
import { ToggleTemplateType } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { SingleFoldFactory } from '../../SingleFoldStyle/SingleFoldStyleFactory';
import { ToggleScene } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { ScreenStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/ScreenStatusVm';
import { StorageAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StorageAdapter';

const EXPECTED_FRAME_RATE_RANGE: ExpectedFrameRateRange = {
  expected: 120,
  min: 120,
  max: 120
};

const TAG = 'Ctrl.SingleFoldControlCenterComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

/**
 * 上滑收起面板阈值
 */
const DISTANCE_FOLD_DROPDOWN: number = 5;

const INDEX_HEADER: number = 0;

const DEFAULT_TOUCH_ID: number = -1;
const TOUCH_NUM_MAX: number = 500;

const BOTTOM_HOT_AREA = 32;
const TOGGLE_START_ROW = 3;
const TOP_TOGGLE_ROWS = 3;
const TOP_TOGGLE_ROW_HEIGHT = 72;

/**
 * 主布局隐藏时的参数
 */
const MAIN_PAGE_HIDE_SCALE = 0.95;
const MAIN_PAGE_HIDE_OPACITY = 0.01;

// 主页面布局组件ZINDEX
export const MAIN_LAYOUT_HEAD_BLUR_AREA_ZINDEX: number = 1;

/**
 * Row count of header
 */
const ROW_COUNT_OF_HEADER: number = 2;

const ANI_DELAY: number = 32;

const MEDIA_ITEM_NAME: string = 'mediaCard';
const SUPER_TERMINAL_ITEM_NAME: string = 'superTerminal_brightness';
const TOGGLE_ROW_ITEM_NAME: string = 'quickToggleRow';
const ADD_MORE_BUTTON_NAME: string = 'addMoreButton'
const LIST_INIT_CONTENT: string[] =
  [MEDIA_ITEM_NAME, SUPER_TERMINAL_ITEM_NAME, ADD_MORE_BUTTON_NAME];
const MAX_QUICK_TOGGLE_ROWS: number = 5;

/**
 * 控制中心主页加满开关屏幕下方ListItem行数
 */
const LIST_ITEM_LINES: number = 3;

/**
 * 控制中心根布局
 */
@Component
export struct SingleFoldControlCenterComponent {
  private colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  /**
   * toast提示
   */
  private showToast = (msg: ResourceStr) => {
    Prompt.showToast({
      message: typeof msg === 'string' ? msg : ResUtils.getInnerString(msg),
      showMode: 2
    });
  }

  /**
   * 控制中心样式
   */
  @State style: ControlCenterComponentStyle = StyleConfiguration.getControlCenterComponentStyle();

  @State backgroundOpacity: BackgroundOpacity = BrightnessSharedViewData.getInstance().getBackgroundOpacity();

  /**
   * 是否回收资源
   */
  @Consume trimMemory: boolean;

  /**
   * 是否显示播控、WIFI和蓝牙卡片
   */
  private isShowBigTile: boolean = true;

  @StorageLink('isLandscape') isLandscape: boolean = false;

  /**
   * 下拉事件响应式状态
   */
  @State @Watch('onDropdownChanged') dropDownEventState: ControlCenterPanelDropdownEvent = ControlCenterPanelDropdownEvent.create();

  private animationCount: number = 0;

  /**
   * list高度
   */
  @State listHeight: number = 0;

  /**
   * 控制中心高度
   */
  @State contentHeight: number = 0;

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
   * toggle竖屏状态高度
   */
  @State toggleHeight: number = StyleConfiguration.getControlCenterQuickToggleLayoutStyle().togglePanelHeight;

  /**
   * 控制中心数据
   */
  @State data: ControlCenterData = Controller.getData();

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
  // 二级页面限高
  @State subpageHeight: number = 0;
  @StorageLink('lockStatus') lockStatus: number = 0;
  @Link ccLayoutIndex: ControlCenterLayoutIndex;

  @Link uiExtProxy?: UIExtensionProxy;

  @State viewData: ControlCenterHomeViewData = new ControlCenterHomeViewData();
  @State screenWidth: number = 0;

  @StorageLink('ControlCenterState') controlCenterState: ControlCenterState = ControlCenterState.MAIN_LAYOUT;
  @StorageLink('foldStatusForOuterScreen') foldStatus: number =
    AppStorage.get<number>('foldStatusForOuterScreen') as number;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State quickToggles: string[] = [];
  @State desktopMode: DesktopMode = EmergencyManager.getInstance().getData();

  // 底部点击收起的空白区域高度
  @State tapBlankAreaHeight: number = 0;
  // 底部点击收起的空白区域宽度
  @State tapBlankAreaWidth: string = '100%';
  // 底部上滑收起的空白区域高度
  @State slideUpBlankAreaHeight: number = 0;
  @State @Watch('handleToggleDataChanged') isShowTerminalButton: boolean = LauncherAbilityManagerAdapter.getUserId() === Constants.DEFAULT_USER_ID;

  private lastToggles: string = '';
  private toggleAreaHeight: number = 0;

  private scrollBlurController?: ScrollBlurController;
  private blurArea: RectInfo = new RectInfo();
  @Link scrollBlurViewData: ScrollBlurViewData;

  // controlViewDate
  @State controlViewData: ControlCenterViewData = new ControlCenterViewData();

  private homeViewModel: ControlCenterHomeViewModel =
    new ControlCenterHomeViewModel(this.viewData, this.controlViewData.scroller);

  private animationViewModel: ControlCenterAnimationViewModel =
    new ControlCenterAnimationViewModel(this.controlViewData.animationDataArray,
      LIST_INIT_CONTENT.length + MAX_QUICK_TOGGLE_ROWS + 1);

  // viewModel
  private controlViewModel: ControlCenterViewModel =
    new ControlCenterViewModel(this.controlViewData, this.viewData, this.animationViewModel, this.homeViewModel);

  private singleFoldQuickToggles: string[] = [];

  private mainListWidth: number = ResUtils.getConvertNumber($r('app.float.single_fold_control_center_single_card_width'));

  handleToggleDataChanged() {
    let singleFoldQuickToggleStr = ResUtils.getInnerString($r('app.string.small_screen_toggle_data_default'));
    if (!this.isShowTerminalButton) {
      singleFoldQuickToggleStr = singleFoldQuickToggleStr.replace(',' + FASlotName.FOCUS_MODE, '');
    }
    this.singleFoldQuickToggles = singleFoldQuickToggleStr?.split(',');
    // 根据开关数量的变化动态调整list数组元素数量
    let toggleSize: number = this.singleFoldQuickToggles.length;
    if (toggleSize === 0) {
      log.showInfo('toggleData not initial, return');
      return;
    }
    let currentToggles:string = this.singleFoldQuickToggles.join(',');
    if (this.lastToggles === currentToggles) {
      log.showInfo('same with last time');
      return;
    }
    this.lastToggles = currentToggles;
    let toggleRowLen: number = Math.ceil(toggleSize / QuickToggleController.getInstance().getToggleColumn());
    this.toggleAreaHeight = toggleRowLen * 72;
    this.controlViewData.contentIndexArr = LIST_INIT_CONTENT.slice();
    for (let i = 0; i < toggleRowLen; i++) {
      this.controlViewData.contentIndexArr.splice(i + TOGGLE_START_ROW, 0, TOGGLE_ROW_ITEM_NAME + i);
    }
    for (let i = 0; i < this.controlViewData.contentIndexArr.length; i++) {
      this.controlViewData.contentIndexArr[i] += '_' + i;
    }
    this.quickToggles = singleFoldQuickToggleStr?.split(',');
    this.setBottomBlankAreaHeight();
    log.showInfo('handleToggleDataChanged: %{public}s', this.controlViewData.contentIndexArr.toString())
  }

  aboutToAppear() {
    this.controlViewData.displaySyncObject = displaySync.create();
    // 设置DisplaySync期望的帧率
    this.controlViewData.displaySyncObject?.setExpectedFrameRateRange(EXPECTED_FRAME_RATE_RANGE);
    
    // 注册监听
    Controller.registerListener();
    // 控制中心状态监听
    sEventManager.subscribe('ControlCenterState', this.mainLayoutHideAnim);
    this.handleToggleDataChanged();
    log.showInfo('aboutToAppear. state: ' + this.data.state);
    AppStorageUtil.setOrCreate('isMarkingRenderGroupOfControl', true, new DataProperty(true, false));

    ControlCenterLayoutController.getInstance().setLayoutChangeCallback('SmallScreenControlCenterLayout', (newIndex, prop?) => {
      this.screenWidth = prop?.width ?? this.screenWidth;
    });
    Controller.setHomeViewData(this.viewData);
    Controller.setShowToastMethod(this.showToast);

    Controller.setDefaultBrightening();

    this.blurArea.left = 0;
    this.blurArea.top = 0;
    this.blurArea.height = 32;
    this.blurArea.width = this.screenWidth;
    this.scrollBlurController = new ScrollBlurController(this.controlViewData.scroller, 132);
    this.scrollBlurController?.init(this.blurArea, this.scrollBlurViewData);
    this.homeViewModel.setScrollBlurController(this.scrollBlurController);
    this.controlViewModel.setScrollBlurController(this.scrollBlurController);
  }

  aboutToDisappear() {
    ControlCenterLayoutController.getInstance().setLayoutChangeCallback('SmallScreenControlCenterLayout', undefined);
    // 反注册监听
    Controller.unregisterListener();
    sEventManager.off('ControlCenterState', this.mainLayoutHideAnim);
    Controller.setHomeViewData(undefined);
    EmergencyManager.getInstance().unRegisterDesktopModeChange();
    this.scrollBlurController?.unregister();
    VolumeController.getInstance().releaseVolumeChangeCallback();
    log.showInfo('aboutToDisappear.');
  }

  build() {
    Stack() {
      // 点击和上滑空白处收起
      this.loadClickAndSlideUpBackboard();
      // 主界面
      this.loadMainLayout();
      // home手势背板
      this.loadHomeGestureBackboard();

      if (this.foldStatus === DeviceState.FOLDED_STATE &&
        this.controlCenterState === ControlCenterState.MEDIA_CENTER) {
        this.loadMediaCenterLayout();
      } else if (this.foldStatus === DeviceState.FOLDED_STATE &&
        this.controlCenterState === ControlCenterState.SUB_PANEL &&
        sToggleSubWindowController.getCurrentSubPanelSlot()) {
        // 二级界面
        if (this.updateSubpageHeight()) {
        }
        SubPageLayout({
          contentHeight: this.subpageHeight,
          listHeight: this.listHeight,
          isSingleFoldMode: true
        })
          .id('transition_subpage' + sToggleSubWindowController.getCurrentSubPanelSlot())
          .transition(TransitionEffect
            .opacity(0.99)
            .animation({duration: SUBPAGE_LONG_SPRING_DURATION, curve: Curve.Friction}))
          .gesture(PanGesture({ direction: PanDirection.Horizontal }))
      }

      this.HeadBlurArea()
    }
    .direction(Direction.Ltr)
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Top)
  }

  private updateSubpageHeight(): boolean {
    if (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.subpageVerticalCenter) {
      return false;
    }
    let contentHeight = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.headerHeight +
    this.getTopTogglesHeight() + this.toggleAreaHeight;
    this.subpageHeight = Math.min(contentHeight,
      (this.listHeight - (CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.contentEndOffset as number ?? 0)) -
      ResUtils.getNumber($r('app.float.status_bar_phone_height')))
    log.showInfo(`this.subpageHeight: ${this.subpageHeight}`);
    return true;
  }

  @Builder
  HeadBlurArea() {
    Column()
      .backgroundEffect({ radius: 40 }, { disableSystemAdaptation: true })
      .width(this.screenWidth)
      .height(this.blurArea.height)
      .visibility(this.scrollBlurViewData.getBlurActive() ? Visibility.Visible : Visibility.Hidden)
      .zIndex(MAIN_LAYOUT_HEAD_BLUR_AREA_ZINDEX)
      .accessibilityLevel('yes')
  }

  /**
   * 加载主界面布局
   */
  @Builder
  loadMainLayout() {
    Stack({alignContent: Alignment.Top}) {
      Flex({
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.Start
      }) {
        this.loadMainList()
      }
      .height('100%')
      .opacity(this.data.state === ControlCenterState.MAIN_LAYOUT ? 1 : MAIN_PAGE_HIDE_OPACITY)
      .onTouch((event?: TouchEvent) => this.controlViewModel.onListTouchEvent(event as TouchEvent))
    }
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      log.showInfo('onSizeChange: %{public}d', newValue.height);
      // 更新容器高度
      this.contentHeight = Number(newValue.height);
      this.listHeight = this.contentHeight -
        this.getMainPageOffset() +
        (this.isLandscape ? 0 : 320);
      this.contentHeight -= 132;
      this.setBottomBlankAreaHeight();
    })
    .height('100%')
    .width(this.mainListWidth)
    .scale(this.data.state === ControlCenterState.MAIN_LAYOUT ?
      { x: 1, y: 1, centerY: this.contentHeight * 0.5 + 'vp' } :
      { x: MAIN_PAGE_HIDE_SCALE, y: MAIN_PAGE_HIDE_SCALE, centerY: this.contentHeight * 0.5 + 'vp' })
    .accessibilityLevel(this.data.state === ControlCenterState.MAIN_LAYOUT ? 'auto' : 'no-hide-descendants')
  }

  @Builder
  loadMediaCenterLayout() {
    MediaPlaybackComponent().zIndex(1).id('mediaPlaybackComponent')
      .gesture(PanGesture({ direction: PanDirection.Horizontal }))
  }

  @Styles
  ListStyle() {
    .height(this.listHeight)
    .clip(this.isLandscape || this.controlViewData.shouldClip ?
    new Rect({
      width: this.screenWidth + 200,
      height: '100%'
    }).position({x: -100, y: 0}) : false)
    .padding(this.screenWidth && CC_LAYOUT_CONFIGS[this.controlViewData.ccLayoutIndex]?.scrollPadding)
    .width(this.mainListWidth)
  }

  @Builder
  loadMainList() {
    List({ scroller: this.controlViewData.scroller, space: 12 }) {
      this.ForEachBuilder()
      this.BlankArea()
    }
    .contentEndOffset(16)
    .contentStartOffset(40)
    .scrollBar(BarState.Off)
    .chainAnimation(this.controlViewData.openChain)
    .cachedCount(LIST_ITEM_LINES)
    .chainAnimationOptions({
      minSpace: 12,
      maxSpace: 32,
      edgeEffect: ChainEdgeEffect.STRETCH
    })
    .enableScrollInteraction(this.viewData.blankLayoutWeight === 1)
    .alignListItem(ListItemAlign.Center)
    .ListStyle()
    .onScrollStart(() => {
      log.showInfo('onScrollStart');
      this.uiExtProxy?.send({ 'method': 'canClick', 'param': 0, });
      this.controlViewData.shouldClip = true;
    })
    .onReachStart(() => {
      log.showInfo(`onReachStart`);
      this.controlViewData.listController.isReachTop = true;
    })
    .onDidScroll(() => {
      if (this.controlViewModel.isScrollByFocus()) {
        this.scrollBlurController?.onListScrollWithBlurAnimate();
      }
      // 在下拉停止时处理头部区域位置，避免出现头部区域不复位
      this.controlViewModel.headerFollowEffect();
    })
    .onWillScroll((scrollOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
      if (scrollOffset === 0) {
        log.showInfo('not deal with zero return');
        return;
      }
      if (scrollOffset > 0 && this.controlViewData.listController.isReachTop) {
        this.controlViewData.listController.isReachTop = false;
      }
      // 不处理Scroller的方法触发的回调
      if (scrollSource === ScrollSource.SCROLLER) {
        log.showInfo('handleOnWillScroll from scroller')
        return;
      }
      return this.controlViewModel.handleOnWillScroll(scrollOffset);
    })
    .onScrollStop(() => {
      log.showInfo('onScrollStop');
      this.uiExtProxy?.send({ 'method': 'canClick', 'param': 1, });
    })
    .edgeEffect(EdgeEffect.Spring, { alwaysEnabled: true })
  }

  @Builder
  ForEachBuilder() {
    ForEach(this.controlViewData.contentIndexArr, (item: string, index?: number) => {
      this.loadEachItem(item, index);
    }, (item: string, index?: number) => item)
  }

  @Builder
  BlankArea() {
    if (this.viewData.blankLayoutWeight < 1) {
      ListItem() {
      }
      .height('100%')
      .width('100%')
    }
  }

  buildItem(item: string) : boolean {
    log.showInfo('build Item:' + item);
    return true;
  }

  @Builder
  loadEachItem(item: string, index: number | undefined) {
    if (item.startsWith(MEDIA_ITEM_NAME) && this.isShowBigTile) {
      // 媒体卡片及WIFI蓝牙卡片
      ListItem() {
        this.loadMediaCardLayout(index as number);
      }
      .visibility(VisibilityController.getToggleRowVisibility(this.backgroundOpacity.backgroundOpacity))
    } else if (item.startsWith(SUPER_TERMINAL_ITEM_NAME) &&
    CC_LAYOUT_CONFIGS[this.controlViewData.ccLayoutIndex]?.showMediaAboveCardToggles) {
      ListItem() {
        this.loadVolumeAndBrightLayout(index as number);
      }
    } else if (item.startsWith(TOGGLE_ROW_ITEM_NAME)) {
      ListItem() {
        QuickToggleRow({
          animationData: this.controlViewData.animationDataArray[index as number + 1],
          slots: this.getRowElements(this.quickToggles, index as number)
        })
          .id('Ctrl.QuickToggleRow_' + index)
          .visibility(VisibilityController.getToggleRowVisibility(
            this.backgroundOpacity.backgroundOpacity));
      }
    } else if (item.startsWith(ADD_MORE_BUTTON_NAME) && this.viewData?.replaceBrightnessBar) {
      ListItem() {
        AddMoreToggleButton()
          .transition(TransitionEffect.OPACITY.animation({ duration: 350, curve: Curve.Friction }))
      }
      .align(Alignment.Top)
      .height(CC_LAYOUT_CONFIGS[this.controlViewData.ccLayoutIndex]?.brightnessHeight)
    }
  }

  private getRowElements(arr:string[], index: number): string[] {
    // 开关的起始行数是index = TOGGLE_START_ROW
    let startIndex = index - TOGGLE_START_ROW;
    if (startIndex < 0) {
      log.showWarn('index is less than ' + TOGGLE_START_ROW);
      startIndex = 0;
    }
    let start = startIndex * QuickToggleController.getInstance().getToggleColumn();
    let end = start + QuickToggleController.getInstance().getToggleColumn();
    let resArr = arr.slice(start, end);
    return resArr;
  }

  private mainLayoutHideAnim = (state: ControlCenterState) => {
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
            this.scrollBlurController?.onListScrollWithBlur();
          } catch (error) {
            log.showError(`scrollBlurController error ${error}`);
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

  @Builder
  toggleLoader(slot: string, isDragging: boolean) {
    ToggleComponent({
      toggleId: slot,
      toggleViewModel: QuickToggleController.getInstance().createToggleModelAndInit(slot),
      toggleStyle: SingleFoldFactory.getInstance().createBasicStyle(),
      templateType: ToggleTemplateType.BASIC,
      isEditMode: true,
      toggleScene: ToggleScene.SINGLE_FOLD_OUTER_SCREEN
    })
      .accessibilityGroup(this.controlViewData.isEditMode && this.isAccessibilityMode ? true : false)
      .accessibilityLevel(this.controlViewData.isEditMode && this.isAccessibilityMode ? 'no' : 'auto')
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
  }

  /**
   * 底部上滑home手势
   */
  @Builder
  loadHomeGestureBackboard() {
    Stack() {
      // 绑定上滑收起的底部空白区域，该范围最小为36vp
      Column()
        .height(BOTTOM_HOT_AREA)
        .width('100%')
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
    .height('100%')
    .width('100%')
    .hitTestBehavior(HitTestMode.Transparent)
    .alignContent(Alignment.BottomEnd)
    .accessibilityLevel('no')
  }

  // 空白区域受到快捷开关行数、IOT卡片区域高度变化的影响
  private setBottomBlankAreaHeight() {
    log.showInfo('setBottomBlankAreaHeight' + this.contentHeight + ':' + this.toggleAreaHeight);
    if (this.controlViewData.ccLayoutIndex !== ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      this.tapBlankAreaHeight = this.contentHeight - this.getTopTogglesHeight() -
        this.toggleAreaHeight;
      log.showInfo('tapBlankAreaHeight' + this.tapBlankAreaHeight);
      this.tapBlankAreaWidth = '100%';
      this.slideUpBlankAreaHeight = Math.max(this.tapBlankAreaHeight, BOTTOM_HOT_AREA);
    } else {
      this.tapBlankAreaHeight = this.contentHeight - this.style.landscapeOffset -
        this.toggleAreaHeight;
      log.showInfo('tapBlankAreaHeight' + this.tapBlankAreaHeight);
      this.tapBlankAreaWidth = '50%';
      this.slideUpBlankAreaHeight = BOTTOM_HOT_AREA;
    }
  }

  private getTopTogglesHeight(): number {
    let topToggleRows: number = TOP_TOGGLE_ROWS;
    log.showInfo('topToggleRows:' + topToggleRows);
    return topToggleRows * TOP_TOGGLE_ROW_HEIGHT;
  }

  @Builder
  mediaCardBlankArea() {
    // 点击空白处收起控制面板
    Column()
      .layoutWeight(1)
      .width(CC_LAYOUT_CONFIGS[this.controlViewData.ccLayoutIndex]?.singleCardWidth)
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          GestureGroup(GestureMode.Parallel,
            // 只接收上滑手势，屏蔽其它方向的滑动手势
            PanGesture({ direction: PanDirection.Up, distance: DISTANCE_FOLD_DROPDOWN })
              .onActionStart(event => {
                DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP);
                DropDownPanelManager.animToDismiss();
              }),
            PanGesture()
          ),
          TapGesture()
            .onAction((event?: GestureEvent) => {
              DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
              DropDownPanelManager.animToDismiss();
            })
        )
      )
      .accessibilityLevel(this.isAccessibilityMode ? 'no' : 'yes')
  }

  @Builder
  loadMediaCardLayout(index: number, mediaLandscape: boolean = false) {
    MediaCardLayout({
      animationData: this.controlViewData.animationDataArray[index + 1],
      isShowWifiCard: true
    })
      .height(undefined)
      .opacity(this.viewData.mediaCardOpacity)
  }

  // 音量条与亮度条布局
  @Builder
  loadVolumeAndBrightLayout(index: number) {
    VolumeAndBrightLayout({
      animationData: this.controlViewData.animationDataArray[index + 1],
      isShowButton: CC_LAYOUT_CONFIGS[this.controlViewData.ccLayoutIndex]?.showMediaAboveCardToggles,
      isSingleFoldStyle: true
    })
      .opacity(this.viewData.superTerminalOpacity)
  }

  private getMainPageOffset(): number {
    return 0;
  }

  /**
   * 下拉事件参数改变回调
   */
  onDropdownChanged() {
    this.controlViewModel.onDropdownChanged(this.dropDownEventState);
  }
}
