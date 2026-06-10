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

import Curves from '@ohos.curves';
import performanceMonitor from '@ohos.arkui.performanceMonitor';

import { ScrollBlurController } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurController';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import {
  DropDownEvent,
  DropDownStatus,
  EvtBus,
  ViewType,
  ViewManagerPolicy,
  PluginCardChangeEvent,
  TargetPanel,
  TargetChangeState
} from '@ohos/frameworkwrapper';
import {
  AnimateToScheduleUtils,
  Trace,
  TraceUtil,
  AppStorageUtil,
  DomainName,
  DataProperty,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { ColorInvertTool } from '@ohos/systemuicommon/src/main/ets/utils/ColorInvertTool';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';
import {
  ControlCenterAccessibilityDataModel
} from '@ohos/controlcentercommon/src/main/ets/accessibility/AccessibilityDataModel';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import {
  CC_LAYOUT_CONFIGS,
  ControlCenterLayoutIndex
} from '../controller/ControlCenterLayoutController';
import { ControlCenterPanelDropdownEvent } from '../model/ControlCenterPanelDropdownEvent';
import Controller from '../controller/ControlCenterController';
import { ControlCenterViewData } from '../vm/ControlCenterViewData';
import { ControlCenterHomeViewModel } from '../vm/ControlCenterHomeViewModel';
import { ControlCenterHomeViewData } from '../vm/ControlCenterHomeViewData';
import { PrivacySensorViewModel } from './PrivacySensorViewModel';
import { ControlCenterAnimationViewModel } from './ControlCenterAnimationViewModel';
import { BrightnessSharedViewData } from './BrightnessViewModel';
import ControlCenterAnim from '../common/ControlCenterAnimParm';

const TAG = 'Ctrl.ControlCenterViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const DEFAULT_TOUCH_ID: number = -1;
const TOUCH_NUM_MAX: number = 500;
const ANI_DELAY: number = 32;
const TOGGLE_START_ROW = 3;
const INDEX_HEADER: number = 0;

const MEDIA_ITEM_NAME: string = 'mediaCard';
const SUPER_TERMINAL_ITEM_NAME: string = 'superTerminal_brightness';
const TOGGLE_ROW_ITEM_NAME: string = 'quickToggleRow';
const ADD_MORE_BUTTON_NAME: string = 'addMoreButton';
const LIST_INIT_CONTENT: string[] =
  [MEDIA_ITEM_NAME, SUPER_TERMINAL_ITEM_NAME, ADD_MORE_BUTTON_NAME];

/**
 * Row count of header
 */
const ROW_COUNT_OF_HEADER: number = 2;

/**
 * 控制中心viewModel
 */
export class ControlCenterViewModel {
  private dropDownStatus: DropDownStatus = DropDownPanelManager.getDropDownStatus();

  /**
   * onTouch事件当前起作用的手指id
   */
  private currentTouchId: number = DEFAULT_TOUCH_ID;

  /**
   * onTouch事件当前执行编号
   */
  private currentTouchNo: number = 0;

  /**
   * 滑动事件X轴起始点
   */
  private startX: number = 0;

  /**
   * 滑动事件Y轴起始点
   */
  private startY: number = 0;

  /**
   * 上一次手指的y坐标
   */
  private lastY: number = 0;

  /**
   * y轴下拉跟手系数
   */
  private transYCoefficient: number = 2 / 3;

  private lastToggles: string = '';

  private toggleAreaHeight: number = 0;

  /**
   * 前一页面类型
   */
  private lastPanelType: TargetPanel = TargetPanel.NONE;

  /**
   * onTouch事件上一次执行编号
   */
  private lastTouchNo: number = 0;

  private isTouching: boolean = false;

  private viewData: ControlCenterViewData;

  /**
   * 控制中心显隐动画相关参数
   */

  private animationCount: number = 0;

  private animationViewModel: ControlCenterAnimationViewModel;

  private scrollBlurController?: ScrollBlurController;

  private homeViewData: ControlCenterHomeViewData;

  private homeViewModel: ControlCenterHomeViewModel;

  private mediaTransitionLink: AbstractProperty<number> = AppStorage.setAndRef('mediaTransitionFlag', 0);


  constructor(viewData: ControlCenterViewData, homeViewData: ControlCenterHomeViewData,
    animationViewModel: ControlCenterAnimationViewModel, homeViewModel: ControlCenterHomeViewModel) {
    this.viewData = viewData;
    this.homeViewData = homeViewData;
    this.animationViewModel = animationViewModel;
    this.homeViewModel = homeViewModel;
  }

  public setScrollBlurController(scrollBlurController: ScrollBlurController) {
    this.scrollBlurController = scrollBlurController;
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
  public onListTouchEvent(event: TouchEvent) {
    // 如果状态栏下拉手势还未结束或者当前窗口未显示，新手势不起作用
    if (this.dropDownStatus.isTouchingStatusBar) {
      log.showInfo(`hand gesture conflict, isTouchingStatusBar:${this.dropDownStatus.isTouchingStatusBar}`);
      return;
    }
    // 如果前一个触控手势还未结束，新手势不起作用
    let changedTouchId = event.changedTouches[0].id;
    if (this.currentTouchId !== DEFAULT_TOUCH_ID && changedTouchId !== this.currentTouchId) {
      log.showInfo(`hand gesture conflict: ${event.changedTouches[0].id} currentTouchId:${this.currentTouchId}`);
      return;
    } else if (this.currentTouchId !== changedTouchId) {
      this.currentTouchNo = (this.currentTouchNo + 1) % TOUCH_NUM_MAX;
    }
    this.currentTouchId = changedTouchId;
    switch (event.type as TouchType) {
      case TouchType.Down:
        this.onTouchDown(event)
        break;
      case TouchType.Move:
        this.onTouchMove(event)
        break;
      case TouchType.Up:
      case TouchType.Cancel:
        this.onTouchCancel(event)
        break;
    }
  }

  private onTouchMove(event: TouchEvent) {
    if (this.startY === -1) {
      log.showInfo('startY is not init, no need deal with');
      return;
    }

    // 不处理横滑事件
    let diffX = event.changedTouches[0].x - this.startX;
    let diffY = Math.abs(event.changedTouches[0].y - this.startY);
    if (DropDownPanelManager.getDropDirection(diffX, diffY) !== TargetChangeState.VERTICAL) {
      log.showDebug(`direction is not vertical or below min distance, return`);
      return;
    }

    this.viewData.relativeDistance = event.changedTouches[0].y - this.startY;
    log.showDebug(`onTouchEvent Move-- newY: ${event.touches[0].y} startY:${this.startY}, isAtEnd: ${this.viewData.scroller.isAtEnd()}`);
    if (this.viewData.relativeDistance > 0) {
      this.viewData.hasScrollDown = true;
    }
    // 当列表触底后，再次向上滑动时，达到阈值需要收起面板，计算向上位移是否达到收起面板阈值
    if (!this.viewData.hasScrollDown && this.viewData.startWhenListReachBottom &&
      this.startY > 0 && this.viewData.relativeDistance < DropDownPanelManager.getFoldDropDownSlop() &&
      this.lastTouchNo == this.currentTouchNo) {
      log.showDebug(`slide up to close the panel, startY is ${this.startY}, endY is ${this.viewData.relativeDistance}`);
      if (DropDownPanelManager.isPanelDismissing()) {
        return;
      }
      DropDownPanelManager.setDismissReason(PanelDismissReason.SLIDE_UP_WHEN_REACH_END);
      DropDownPanelManager.animToDismiss();
      if (event.stopPropagation) {
        AppStorageUtil.setOrCreate('isInStatusBarGesture', false, new DataProperty(false, false));
        event.stopPropagation();
      }
    }
  }

  private onTouchDown(event: TouchEvent) {
    log.showInfo(`onTouchEvent Down, reach top: ${this.viewData.listController.isReachTop}, isAtEnd: ${this.viewData.scroller.isAtEnd()}`);
    this.isTouching = true;
    this.lastTouchNo = this.currentTouchNo;
    this.viewData.translateY = 0;
    this.viewData.hasScrollDown = false;
    DropDownPanelManager.clearDropDirection();
    this.startY = event.changedTouches[0].y;
    this.startX = event.changedTouches[0].x;
    this.lastY = this.startY;
    this.viewData.startWhenListReachTop = this.viewData.listController.isReachTop;
    this.viewData.startWhenListReachBottom = this.viewData.scroller.isAtEnd();
    log.showDebug(`set startY to ${this.startY}, set startX to ${this.startX}`);
    // 开始每帧回调
    this.viewData.displaySyncObject?.start();
  }

  private onTouchCancel(event?: TouchEvent) {
    this.isTouching = false;
    this.currentTouchId = DEFAULT_TOUCH_ID;
    this.startY = -1;
    this.viewData.translateY = 0;
    if (event) {
      log.showDebug(`onTouchEvent up-- upY: ${event?.changedTouches[0].y}`);
    }
    // 停止每帧回调
    this.viewData.displaySyncObject?.stop();
  }

  /**
   * 卡片透明度变化动画
   *
   * @param isShow 面板显示or隐藏
   */
  public startControlCenterAnim(isShow: boolean): void {
    log.showInfo(`startControlCenterAnim start, isShow: ${isShow}`);
    if (isShow) {
      this.showControlCenterAnim();
    } else {
      this.hideControlCenterAnim();
    }
  }

  private showControlCenterAnim(): void {
    log.showInfo('IntoCC start');
    // 兜底处理拖动亮度条被异常打断，控制中心透明度没有恢复为1的情况
    if (this.viewData.backgroundOpacity.backgroundOpacity === 0) {
      log.showInfo('recover mainLayout opacity');
      BrightnessSharedViewData.getInstance().reset();
    }
    this.homeViewData.resetParam();
    this.viewData.listController.isReachTop = true;
    this.viewData.openChain = true;
    this.viewData.shouldClip = false;
    this.viewData.isHideAnimStarted = false;
    PrivacySensorViewModel.getInstance().initData();
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
    performanceMonitor.begin('INTO_CC_ANI', performanceMonitor.ActionType.FIRST_MOVE);
    let requestEvent = PluginCardChangeEvent.getInstance(PluginCardChangeEvent.PLUGIN_CARD_SHOW);
    EvtBus.post(PluginCardChangeEvent, requestEvent);

    let totalDelay = 0;
    for (let i = 0; i < this.animationViewModel.viewDataArray.length; i++) {
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
        this.animationViewModel.viewDataArray[i].opacity = 1.0;
        this.animationViewModel.viewDataArray[i].scale = 1.0;
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
        this.animationViewModel.viewDataArray[i].itemTranslate = 0;
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
      Controller.setLastBackgroundType(type);
      log.showInfo('start change label color type:' + type);
      ColorInvertTool.getInstance().changeLabelColor(type);
    }
  }

  private hideControlCenterAnim(): void {
    if (!ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN)) {
      log.showInfo('window already hide');
      this.animationViewModel.resetData(false);
      return;
    }
    if (this.viewData.progress === 0) {
      log.showInfo('no need to do hide anim when already hide');
      return;
    }
    log.showInfo('ExitCC start');
    if (this.viewData.listController.isReachTop) {
      this.viewData.shouldClip = false;
    }
    TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
    this.viewData.isHideAnimStarted = true;
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
      log.showInfo('IntoCC/ExitCC end ; All Control Center animation finish, mark renderGroup false.');
      this.viewData.dropDownEvent.pullFraction = 1;
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
      TraceUtil.endTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
      Trace.end(Trace.CORE_METHOD_START_DROP_DOWN_PANEL);
      performanceMonitor.end('INTO_CC_ANI');
      performanceMonitor.end('EXIT_CC_ANI');
    }
  }

  /**
   * 下拉事件参数改变回调
   */
  public onDropdownChanged(dropDownEventState: ControlCenterPanelDropdownEvent) {
    log.showInfo(`onDropdownChanged, dropDownEvent: ${dropDownEventState.target}--${dropDownEventState.progress}--${dropDownEventState.translateY}, progress: ${this.viewData.progress}, translateY: ${this.viewData.translateY}`);
    this.setVisible(this.viewData.dropDownEvent);
    // 非控制中心，不处理
    if (dropDownEventState.target !== TargetPanel.CONTROL_CENTER_PANEL) {
      log.showDebug('back to main page');
      let currentState = this.viewData.data.state;
      this.onControlCenterStateChanged(ControlCenterState.MAIN_LAYOUT);
      if (currentState === ControlCenterState.SUB_PANEL) {
        sToggleSubWindowController.hideWindow();
      } else if (this.viewData.isEditMode || currentState === ControlCenterState.TOGGLE_EDIT) {
        this.viewData.isEditMode = false;
        this.homeViewModel.hideEditPanelDirectly();
      }
      // 下拉进入通知中心会走进该分支，初始化控制中心布局。因为左滑能直接切换到控制中心，需要提前加载好
      if (dropDownEventState.target === TargetPanel.NOTIFICATION_PANEL &&
        this.lastPanelType === TargetPanel.NONE) {
        this.setContentTranslateY(0);
        this.scrollBlurController?.resetScroll();
        this.showControlCenterDirectly(true);
      }
      // 收起通知中心会走进该分支，隐藏控制中心布局
      if (dropDownEventState.target === TargetPanel.NONE &&
        this.lastPanelType === TargetPanel.NOTIFICATION_PANEL) {
        this.showControlCenterDirectly(false);
      }
      // 切换到通知中心，复位
      if (this.lastPanelType === TargetPanel.CONTROL_CENTER_PANEL) {
        this.scrollBlurController?.resetScroll();
      }
      this.lastPanelType = dropDownEventState.target;
      return;
    }
    // 需要显示下拉面板时初始化亮度值
    if (this.lastPanelType === TargetPanel.NONE &&
      dropDownEventState.target === TargetPanel.CONTROL_CENTER_PANEL) {
      Controller.updateUIFromCache();
    }
    // 到达展开阈值，卡片执行opacity动画
    if ((this.viewData.progress < 1 && dropDownEventState.progress === 1 &&
      dropDownEventState.targetChanged !== TargetChangeState.HORIZONTAL) ||
      (this.viewData.progress === 1 && this.lastPanelType === TargetPanel.NONE)) {
      this.setContentTranslateY(0);
      this.startControlCenterAnim(true);
      // 每次下拉回到列表顶部
      this.scrollBlurController?.resetScroll();

      // 防止下次回调慢不能及时改变列表触底状态
      this.viewData.listController.isReachTop = true;
    }
    if (this.viewData.progress === 1) {
      // 到达收起阈值，卡片执行opacity动画
      if (dropDownEventState.progress < 1) {
        this.startControlCenterAnim(false);
      }
      if (dropDownEventState.translateY >= 0) {
        if (this.viewData.translateY > 0 && dropDownEventState.translateY === 0) {
          let itemSize: number = this.getAnimArraySize();
          this.animationViewModel.touchEndCheckAnim(this.viewData.progress, itemSize,
            DropDownPanelManager.isStartFromPanelStatusBar() ? false : true);
          DropDownPanelManager.setStartFromPanelStatusBar(false);
        }
        this.viewData.translateY = dropDownEventState.translateY;
        if (this.viewData.translateY > 0) {
          // 当列表在触顶状态的时候下拉才跟手，不在触顶状态不处理跟手动效
          if (!this.viewData.listController.isReachTop) {
            log.showDebug(`only move when list reach top`);
            return;
          }
          this.setContentTranslateY(this.viewData.translateY * this.transYCoefficient,
            DropDownPanelManager.isStartFromPanelStatusBar() ? false : true);
        }
      }
    }
    this.viewData.progress = dropDownEventState.progress;
    this.lastPanelType = dropDownEventState.target;
  }

  // 根据下拉事件的属性设置可见状态
  private setVisible(dropDownEvent: DropDownEvent): void {
    let isShowPanelContent: boolean = dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL ||
      dropDownEvent.targetChanged == TargetChangeState.HORIZONTAL_UP_BACK ||
      dropDownEvent.targetChanged == TargetChangeState.VERTICAL_FLING;
    Controller.setControlCenterVisible(dropDownEvent.target == TargetPanel.CONTROL_CENTER_PANEL ||
      isShowPanelContent);
    Controller.shieldVolumePanelCheck();
  }

  private showControlCenterDirectly(isIotLoadCache: boolean): void {
    log.showInfo(`controlCenterEnterDirectly start, is show is ${isIotLoadCache}`);
    this.viewData.isHideAnimStarted = false;
    if (isIotLoadCache) {
      this.viewData.shouldClip = false;
    } else {
      this.viewData.progress = 0;
    }
    this.viewData.dropDownEvent.pullFraction = 1;

    // Control Center Initialization
    this.animationViewModel.resetData(isIotLoadCache);
  }

  private setContentTranslateY(newValue: number, isStretch?: boolean) {
    for (let i = 0; i < this.getAnimArraySize(); i++) {
      // 过界保护
      if (i >= this.viewData.animationDataArray.length) {
        return;
      }
      if (isStretch) {
        this.viewData.animationDataArray[i].translate = newValue + newValue * 0.05 * i;
      } else {
        this.viewData.animationDataArray[i].translate = newValue + newValue * 0.02 * i;
      }
    }
  }

  private getAnimArraySize(): number {
    return this.viewData.contentIndexArr.length + 1;
  }

  /**
   * 控制中心状态切换回调
   *
   * @param state 新状态值
   */
  public onControlCenterStateChanged(state: ControlCenterState): void {
    Controller.shieldVolumePanelCheck(state);
    if (this.viewData.data.state === state) {
      log.showInfo(`onControlCenterStateChanged, new state:${state}, same with last.`);
      return;
    }
    if (state !== ControlCenterState.MAIN_LAYOUT) {
      this.viewData.animationDataArray[INDEX_HEADER].translate = 0;
    }
  }

  public handleOnWillScroll(scrollOffset: number): void | ScrollResult {
    this.headerFollowEffect();
    if (this.viewData.startWhenListReachBottom && this.viewData.startWhenListReachTop) {
      // 不超一屏的时候，向上滑动收起，为了保持收起动效正常，列表不滚动
      try {
        if (!this.viewData.hasScrollDown &&
          Math.round(this.viewData.scroller.getItemRect(0).y) <=
            (CC_LAYOUT_CONFIGS[this.viewData.ccLayoutIndex]?.contentStartOffset as number) &&
          this.viewData.relativeDistance < 0) {
          this.scrollBlurController?.inactiveScrollerBlur();
          this.viewData.shouldClip = false;
          this.viewData.openChain = false;
          let res: ScrollResult = { offsetRemain: 0 };
          return res;
        }
      } catch (err) {
        log.showError(`getItemRect failed, err:${err}`);
      }
      // 不超一屏的时候，需要有跟手拖拽越界回弹效果
      this.scrollBlurController?.onListScrollWithBlur();
      let res: ScrollResult = { offsetRemain: scrollOffset };
      return res;
    }
    // 超一屏的时候，从底部开始向上滑动，为了保持收起动效正常，列表不滚动
    if (!this.viewData.hasScrollDown && this.viewData.startWhenListReachBottom &&
    this.viewData.scroller.isAtEnd() && this.viewData.relativeDistance < 0) {
      this.viewData.openChain = false;
      let res: ScrollResult = { offsetRemain: 0 };
      return res;
    }
    // 超一屏的时候，滑动和跟手拖拽越界回弹效果
    if (!this.viewData.isHideAnimStarted) {
      this.scrollBlurController?.onListScrollWithBlur();
    }
    let res: ScrollResult = { offsetRemain: scrollOffset };
    return res;
  }

  // 之所以分开在onScroll处理头部按钮的跟随效果，因为onScrollFrameBegin在过界回弹的时候收不到回调，后续sdk升级可用onWillScroll代替
  public headerFollowEffect() {
    if (this.viewData.ccLayoutIndex !== ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      try {
        let rectInfo = this.viewData.scroller.getItemRect(0);
        if (Math.round(rectInfo.y) > (CC_LAYOUT_CONFIGS[this.viewData.ccLayoutIndex]?.contentStartOffset as number)) {
          this.viewData.animationDataArray[INDEX_HEADER].translate =
            (rectInfo.y - (CC_LAYOUT_CONFIGS[this.viewData.ccLayoutIndex]?.contentStartOffset as number)) * 0.95;
        } else {
          this.viewData.animationDataArray[INDEX_HEADER].translate = 0;
        }
      } catch (err) {
        log.showError(`getItemRect failed, err:${err}`);
      }
    }
  }

  public static onKeyPreForbidAction(event: KeyEvent, direction: number): boolean {
    return direction === event.keyCode;
  }

  private mainLayoutHideAnim(state: number) {
    if (state !== ControlCenterState.MAIN_LAYOUT) {
      // 主布局淡出动画
      animateTo({
        curve: Curve.Friction,
        duration: 100
      }, () => {
        this.viewData.data.state = state;
      });
      // 通过animateTo而不是setTimeout的方式确保模糊消失一定在主布局淡出之后执行
      animateTo({
        delay: 80,
        curve: Curve.Friction,
        duration: 5
      }, () => {
        this.scrollBlurController?.inactiveScrollerBlur();
      });
    } else {
      setTimeout(() => {
        if (state === ControlCenterState.MAIN_LAYOUT) {
          try {
            this.scrollBlurController?.onListScrollWithBlur();
          } catch (error) {
            log.showError(`scrollBlurController error`);
          }
        }
      }, 180);
      // 主布局显示动画
      animateTo({
        delay: 160,
        curve: Curves.cubicBezierCurve(0.42, 0.00, 0.44, 1.00),
        duration: 200
      }, () => {
        this.viewData.data.state = state;
      });
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
    let flag = this.mediaTransitionLink.get();
    this.mediaTransitionLink.set(flag + 1);
    // 一镜到底弹簧动画
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
    animateTo({
      curve: Curves.interpolatingSpring(0, 1, 228, 25),
      onFinish: () => {
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

  public isScrollByFocus(): boolean {
    return !this.homeViewModel.getIsEditing() && !this.isTouching &&
      !this.viewData.isHideAnimStarted && this.viewData.dropDownEvent.progress === 1;
  }
}