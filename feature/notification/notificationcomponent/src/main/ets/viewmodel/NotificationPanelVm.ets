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
  CellularDataVm,
  DeviceInfoVm,
  DropdownVm,
  INotificationPanelVm,
  NotificationBaseVm,
  PanelVmEvent
} from '@ohos/systemuicommon/newIndex';
import { DropDownPanelManager, EventBroadcast, SysUiWindowType } from '@ohos/systemuicommon/Index';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  DropDownPanelManagerWrapper,
  EventConstants,
  sEventManager,
  TargetChangeState,
  TargetPanel,
  DropDownEvent,
  DeviceHelper,
  ViewType,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { NotificationItemAppearAnimation } from '../animation/NotificationItemAppearAnimation';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import {
  EventEmitter,
  LiveCardShowAnimationEventUtil, NotificationDataManager,
  InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { uiEffect } from '@kit.ArkGraphics2D';
import { ResUtils } from '@ohos/windowscene';
import {
  NotificationPanelSlideParams,
  NotificationSysEventReporter,
} from '@ohos/systemuicommon/src/main/ets/utils/NotificationSysEventReporter';
import { NtfCenterDropDownEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { ViewManagerAdapter } from '@ohos/systemuicommon';

const TAG = 'NotificationPanelVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * item出场动画时延
 */
const APPEAR_DELAY: number = 32;

/**
 * list整体y轴下拉跟手系数（权重1.05 * 跟手系数2/3）
 */
const LIST_FOLLOW_COEFFICIENT = 0.7;

/**
 * 动效开始前，通知item初始的缩放比例。
 */
const INIT_ITEM_SCALE: number = 0.8;

/**
 * 下拉通知中心，不同位置卡片向上位移距离，取固定值，大于6行通知取112。
 */
const UPWARDS_TRANS_Y_ARRAY: number[] = [26, 24, 44, 54, 75, 112];

const NTF_HEADER_TIME_TEXT_ID: string = 'NotificationHeaderView_TimeView_Text_timeText';
/**
 * 模糊区域高度及向上偏移(-40)
 * 横屏布局 47 + 40的向上偏移, 防止双中心切换时透出
 * 非横屏布局 75 + 40的向上偏移, 防止双中心切换时透出
 */
const BLUR_AREA_HEIGHT_LANDSCAPE_LAYOUT = 87;
const BLUR_AREA_HEIGHT = 115;
const BLUR_AREA_TRANSY = -40;
const LANDSCAPE_DIVISOR = 1.6;

@ObservedV2
export class NotificationPanelVm extends NotificationBaseVm implements INotificationPanelVm {
  @Trace public isVisible: boolean = false;
  @Trace public cardWidth: number = 0;
  @Trace public opacity: number = 1;
  @Trace public scale: number = 1;
  /**
   * 通知面板是否显示
   */
  @Trace public isShow: boolean = false;
  /**
   * 面板触摸down点，全局Y轴点，-1无触摸
   */
  @Trace public panelDownWindowY: number = -1;
  /**
   * 是否可响应事件
   */
  @Trace public isResponsive: boolean = true;
  /**
   * 是否需要展示模糊层
   */
  @Trace public isBlurAreaVisible: boolean = false;
  /**
   * 模糊层高度
   */
  @Trace public blurAreaHeight: number = BLUR_AREA_HEIGHT;
  /**
   * 模糊层TransY
   */
  @Trace public blurAreaTransY: number = BLUR_AREA_TRANSY;
  /**
   * 当前下拉进度
   */
  private lastProgress = 0;
  /**
   * 当前下拉面板
   */
  private lastTarget: TargetPanel = TargetPanel.NONE;
  /**
   * 通知列表vm
   */
  protected listVm = this.vmInjector.getListVm()!;
  /**
   * 通知面板头部VM
   */
  protected headerVm = this.vmInjector.getHeaderVm()!;
  /**
   * 更多通知头部VM
   */
  private moreHeaderVm = this.vmInjector.getNotificationMoreHeaderVm()!;
  /**
   * 通知列表滑动VM
   */
  private listScrollerVm = this.vmInjector.getListScrollerVm();
  /**
   * item依次出现动效
   */
  private itemAppearAnimation = new NotificationItemAppearAnimation(this.listScrollerVm, this.moreHeaderVm);
  /**
   * 是否有无效的下拉跟手位移。(列表滚动条滑动过程中，又触发下拉跟手)
   */
  private hasInvalidMoveY = false;
  /**
   * 面板触摸down点，全局X轴点，-1无触摸
   */
  private panelDownWindowX: number = -1;
  /**
   * 是否允许滑动切换双中心
   */
  private allowPanHorizontal: boolean = true;
  /**
   * 面板广播事件
   */
  public emitter: EventEmitter<PanelVmEvent> = new EventEmitter<PanelVmEvent>();

  /**
   * 出场动效是否已执行
   */
  private isAppearAnimExecuted: boolean = false;

  /**
   * 通知中心是否需要横屏布局
   */
  @Computed
  get isLandscapeLayout(): boolean {
    if (DeviceInfoVm.instance.isLandscape) {
      // 大大屏幕机，展开或半展开
      if (DeviceHelper.isFold()) {
        return !DeviceInfoVm.instance.isExpand;
      }
      if (DeviceHelper.isPad()) {
        return false;
      }
      // 直板机跟随屏方向
      return true;
    } else {
      return false;
    }
  }

  @Trace public layoutOptions: FlexOptions = {
    direction: FlexDirection.Column,
    alignItems: ItemAlign.Center,
  }

  @Computed
  get portraitHorizontalDropPanelPosition(): number {
    const deviceWidth = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width);
    if (this.listVm?.width.endsWith('vp')) {
      return (parseInt(this.listVm.width) + deviceWidth) / 2;
    }
    return deviceWidth;
  }

  @Computed
  get landscapeHorizontalDropPanelPosition(): number {
    let horizontalDropPanelPosition = 0;
    const deviceWidth = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width);
    if (this.listVm?.width.endsWith('vp')) {
      horizontalDropPanelPosition += parseInt(this.listVm.width);
    } else {
      horizontalDropPanelPosition += deviceWidth / LANDSCAPE_DIVISOR;
    }
    // 加上时间组件宽度
    horizontalDropPanelPosition += parseInt(this.headerVm?.width ?? '0');
    if (this.vmInjector.getClearButtonVm()?.isShow) {
      // 加上删除按钮的宽度
      horizontalDropPanelPosition += (deviceWidth - horizontalDropPanelPosition +
      ResUtils.getNumber($r('app.float.ntf_clear_button_icon_size'))) / 2;
    }
    return horizontalDropPanelPosition;
  }

  @Computed
  get horizontalDropPanelPosition(): number {
    if (this.isLandscapeLayout) {
      return this.landscapeHorizontalDropPanelPosition
    }
    return this.getDefaultHorizontalDropPanelPosition();
  }

  protected getAccessibilityCompId(): string {
    // 下拉通知中心聚焦时间组件
    return this.vmInjector.getId(NTF_HEADER_TIME_TEXT_ID);
  }

  protected getDefaultHorizontalDropPanelPosition(): number {
    return this.portraitHorizontalDropPanelPosition;
  }

  public onDropdownChange(dropDownEvent: DropDownEvent): void {
    if (!this.isResponsive && dropDownEvent.moveY <= 0) {
      this.isResponsive = true;
    }
    // 面板收起时，滚动条滑动至顶部
    if (this.lastTarget !== dropDownEvent.target && dropDownEvent.target !== TargetPanel.NOTIFICATION_PANEL) {
      this.listScrollerVm?.scrollToTop();
    }
    // 通知中心面板收起时打点
    this.reportPanelHide(dropDownEvent);

    // 处理松手回弹
    if (dropDownEvent.isEndAnimRunning) {
      this.hasInvalidMoveY = false;
      this.isResponsive = true;
      NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.DROPDOWN_MOVE_DOWN)
      // 回弹动效
      this.listReboundAnimation(dropDownEvent);
      log.showInfo('onDropdownChange isEndAnimRunning');
      return;
    }

    // 刷新数据
    this.listVm?.flushCacheMap(dropDownEvent);

    // item依次出场动效
    if (this.isItemAppear(dropDownEvent)) {
      this.itemAppearAnimate();
    }

    if (dropDownEvent.progress < 1) {
      // 重置出场动效执行标记
      this.isAppearAnimExecuted = false;
    }

    // 判断是否需要处理下拉跟手参数
    if (!DropdownVm.instance.isNeedUpdateMoveY || this.hasInvalidMoveY) {
      // 已经设置了不更新下拉跟手参数时，仍然触发了下拉位移，则认为该次位移无效。
      log.showInfo(`onDropdownChange isNeedUpdateMoveY: ${DropdownVm.instance.isNeedUpdateMoveY} \
 hasInvalidMoveY: ${this.hasInvalidMoveY} moveY: ${dropDownEvent.moveY}`);
      if (dropDownEvent.moveY > 0) {
        this.hasInvalidMoveY = true;
      }
      return;
    }

    // 通知面板下拉跟手动效
    if (dropDownEvent.moveY > 0 && this.lastTarget === TargetPanel.NOTIFICATION_PANEL) {
      this.isResponsive = false;
      NotificationDataManager.instance.freeze(NotificationDataManager.REASON.DROPDOWN_MOVE_DOWN, 2000)
      this.followAnimate(dropDownEvent);
    }

    this.lastProgress = dropDownEvent.progress;
    this.lastTarget = dropDownEvent.target;
  }

  /**
   * 面板显示隐藏事件
   */
  public onPanelVisibleChange = (isVisible: boolean, currentRatio: number): void => {
    log.showInfo(`On visible change: ${this.isVisible} -> ${isVisible}  ${currentRatio}`);
    if (isVisible && !this.isVisible && currentRatio >= 0.9) {
      // 广播通知中心显示
      EventBroadcast.broadcastEvent(SysUiWindowType.WINDWO_NTF_CENTER, true);
      // 下拉通知中心打断铃声和振动
      InnerEventUtil.post(NtfCenterDropDownEvent, new NtfCenterDropDownEvent());
      this.isShow = true;
      this.isVisible = isVisible;
      log.showInfo(`${SysUiWindowType.WINDWO_NTF_CENTER} show`);
      LiveCardShowAnimationEventUtil.setLiveCardAnimation();
      // 重置响应，避免控制中心下拉时，通知中心存在下拉跟手但没有松手导致的无法响应
      this.isResponsive = true;
      if (DropdownVm.instance.dropdownEvent.target === TargetPanel.CONTROL_CENTER_PANEL) {
        this.headerVm.showTitleText();
      }
    } else if (!isVisible && this.isVisible) {
      if (currentRatio <= 0.1) {
        EventBroadcast.broadcastEvent(SysUiWindowType.WINDWO_NTF_CENTER, false);
        this.isShow = false;
        this.isBlurAreaVisible = false;
        log.showInfo(`${SysUiWindowType.WINDWO_NTF_CENTER} hide`);
        // 重置响应，避免控制中心下拉时，通知中心存在下拉跟手但没有松手导致的无法响应
        this.isResponsive = true;
        // 面板收起时，重置下拉跟手位移。
        this.resetFollowAnimate();
        // 面板收起时，清理出场动效，避免内存残留。
        this.itemAppearAnimation.clearAnimations();
        this.isVisible = isVisible;
        this.hideDropdownPanle();
        log.showInfo('ExitNC end');
      }
    }
  };

  /**
   * item卡片依次出场动效
   */
  private itemAppearAnimate(): void {
    if (!this.listVm) {
      return;
    }

    if (this.isAppearAnimExecuted) {
      return;
    }
    this.isAppearAnimExecuted = true;
    log.showWarn('do itemAppearAnimate!');

    const startIndex = this.listScrollerVm?.startIndex ?? 0;
    const endIndex = this.listScrollerVm?.endIndex ?? 0;

    // 添加动效参数前执行清理
    this.itemAppearAnimation.clearAnimations();
    for (let i = startIndex; i <= endIndex; i++) {
      const ntf = this.listVm.getListItemByIndex(i, true);
      if (!ntf) {
        this.addMoreHeaderAnimation(i, startIndex, endIndex);
        continue;
      }

      const index = i > this.listVm.mainNtfList.length ? i - 1 : i;
      // 设置初始的位移、缩放比例和透明度
      this.vmInjector.getCardVm(ntf).isInAppearAnim = true;
      if (i !== endIndex) {
        this.vmInjector.getCardVm(ntf).itemAppearReset();
      }
      this.vmInjector.getCardVm(ntf).itemAppearAnimation(INIT_ITEM_SCALE, 0, UPWARDS_TRANS_Y_ARRAY[Math.min(index, 5)]);
      // 添加依次出现动效
      this.itemAppearAnimation.addListItemAnimation({
        // 需要传入实际index，用于进行最后一条通知的堆叠处理
        index: i,
        firstIndex: startIndex,
        lastIndex: endIndex,
        itemId: this.listVm.getItemId(ntf),
        cardVm: this.vmInjector.getCardVm(ntf)
      });
    }

    if (this.listScrollerVm) {
      this.listScrollerVm.startItemTranslateY = 0;
    }

    // 下拉面板场景，延迟32ms，与其他动效错峰执行。
    setTimeout(() => {
      this.itemAppearAnimation.startAnimation().then(() => {
        // 下面的日志不要修改，有测试用例关联
        log.showInfo('ClearNtAni/IntoNC All notification animation finish, mark renderGroup false.');
        this.vmInjector.getListScrollerVm()?.transform();
      });
    }, APPEAR_DELAY);
  }

  /**
   * 增加更多通知标题下拉动效
   */
  private addMoreHeaderAnimation(index: number, startIndex: number, endIndex: number): void {
    if (this.listVm.isMoreHeaderIndex(index)) {
      // 设置初始的缩放比例和透明度
      const firstMoreNtf = this.listVm.getListItemByIndex(index + 1, true);
      this.moreHeaderVm.moreHeaderAppearAnimation(INIT_ITEM_SCALE, 0, UPWARDS_TRANS_Y_ARRAY[Math.min(index, 5)])
      let scale = 1;
      let opacity = 1;
      let transY = 0;
      if (index === endIndex - 1 && firstMoreNtf) {
        // 第一条更多通知下拉后是堆叠态，
        const firstMoreCardVm = this.vmInjector.getCardVm(firstMoreNtf);
        scale = firstMoreCardVm.scale;
        opacity = firstMoreCardVm.opacity;
        transY = this.listScrollerVm?.getEndItemTranslateY() ?? firstMoreCardVm.translateY;
      }
      // 添加出现动效
      this.itemAppearAnimation.addMoreHeaderAnimation({
        index: index,
        firstIndex: startIndex,
        lastIndex: endIndex,
        itemId: firstMoreNtf ? this.listVm.getItemId(firstMoreNtf) : '',
        scale: scale,
        opacity: opacity,
        transY: transY,
      });
    }
  }

  /**
   * list以及item卡片下拉跟手
   */
  protected portraitFollowAnimate(dropDownEvent: DropDownEvent): void {
    if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      this.updateListTransY(dropDownEvent.moveY);
      this.updateHeaderTransY();
    }
  }

  private landscapeFollowAnimate(dropDownEvent: DropDownEvent): void {
    if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      this.updateListTransY(dropDownEvent.moveY);
    }
  }

  protected followAnimate(dropDownEvent: DropDownEvent): void {
    if (this.isLandscapeLayout) {
      this.landscapeFollowAnimate(dropDownEvent);
    } else {
      this.portraitFollowAnimate(dropDownEvent);
    }
  }

  /**
   * 重置跟手位移
   */
  private resetFollowAnimate() {
    this.updateListTransY(0);
    this.updateHeaderTransY();
    this.headerVm.resetFollowHandAnim();
  }

  protected updateListTransY(moveY: number) {
    if (!this.listVm) {
      return;
    }
    // 更新List列表整体位移
    this.listVm.reboundAnim = DropDownPanelManager.getEndAnim();
    this.listVm.translateY = moveY * LIST_FOLLOW_COEFFICIENT;
  }

  protected updateHeaderTransY(): void {
    // 更新面板顶部时间/日历header位移
    this.headerVm.followUpdateTransY(this.listVm.translateY);
  }

  /**
   * 是否是面板显示场景触发item依次出现
   * @returns
   */
  private isItemAppear(dropDownEvent: DropDownEvent) {
    return dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL &&
      dropDownEvent.targetChanged === TargetChangeState.NONE &&
      dropDownEvent.progress === 1 && !DropdownVm.instance.isFromCCToNC;
  }

  /**
   * 松手回弹动效
   */
  private listReboundAnimation(dropDownEvent: DropDownEvent) {
    if (!this.listVm) {
      return;
    }
    // 避免重复触发
    dropDownEvent.isEndAnimRunning = false;

    // 设置list回弹动效
    this.listVm.reboundAnim = DropDownPanelManager.getEndAnim();
    dropDownEvent.moveY = 0;
    DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent(dropDownEvent);
    this.listVm.translateY = 0;
    // 顶部header回弹
    this.headerVm?.followUpdateTransY(0);
  }

  /**
   * 下拉通知中心播报无障碍语音
   */
  @Monitor('isVisible')
  async onPanelVisibleChanged(): Promise<void> {
    if (this.isVisible) {
      await AccessibilityVm.instance.sendEventByResource($r('app.string.ntf_center_title'));
      AccessibilityVm.instance.requestFocusAccessibility(this.getAccessibilityCompId(), true);
      this.refreshDataPlanInfo();
    } else {
      this.resetClearAllStatus();
      this.resetDataPlanInfo();
    }
  }

  private refreshDataPlanInfo(): void {
    if (CellularDataVm.instance.isShowData) {
      log.showInfo(`refreshDataPlanInfo`);
      CellularDataVm.instance.refreshDataPlanInfo();
    }
  }

  private resetDataPlanInfo(): void {
    this.vmInjector.getDataPlanVm()?.reset();
  }

  /**
   * 通知面板触摸事件
   */
  public onTouchEvent = (event: TouchEvent): void => {
    if (event) {
      if (event.type === TouchType.Down) {
        this.panelDownWindowY = event.touches[0].windowY;
        this.panelDownWindowX = event.touches[0].windowX;
        return;
      }
      if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.panelDownWindowY = -1;
        this.panelDownWindowX = -1;
        return;
      }
    }
  }

  private resetClearAllStatus(): void {
    const clearButtonVm = this.vmInjector.getClearButtonVm();
    if (clearButtonVm) {
      clearButtonVm.isClearingAll = false
    }
  }

  /**
   * 监听状态栏触摸事件
   */
  public listenEvent = (): void => {
    sEventManager.subscribe(EventConstants.STATUS_BAR_DROPDOWN_TOUCH, (event: TouchEvent) => {
      this.onTouchEvent(event);
    });
  }
  /**
   * 横滑开始事件
   * @param event 手势
   */
  public onPanHorizontalStart = (event: GestureEvent): void => {
    this.allowPanHorizontal = this.listVm.isAllowPanHorizontal(this.panelDownWindowY, this.panelDownWindowX);
    if (this.allowPanHorizontal) {
      DropdownVm.instance.onPanHorizontalStart(event);
    }
  }
  /**
   * 横滑事件
   * @param event 手势
   */
  public onPanHorizontalMove = (event: GestureEvent): void => {
    if (this.allowPanHorizontal) {
      DropdownVm.instance.onPanHorizontalUpdate(event);
    }
  }
  /**
   * 横滑结束事件
   * @param event 手势
   */
  public onPanHorizontalEnd = (event: GestureEvent): void => {
    if (this.allowPanHorizontal) {
      DropdownVm.instance.onPanHorizontalEnd(event, true);
    }
    this.allowPanHorizontal = true;
  }
  /**
   * 横滑取消事件
   */
  public onPanHorizontalCancel = (): void => {
    if (this.allowPanHorizontal) {
      DropdownVm.instance.touchEndCheckAnim();
    }
    this.allowPanHorizontal = true;
  }
  /**
   * 设置渐变模糊合成滤镜效果
   *
   * @returns filter | undefined 挂载了模糊效果的Filter实例，异常时返回undefined
   */
  public getBlurCompositingFilter(): Filter | undefined {
    try {
      const filter = uiEffect.createFilter();
      return filter.radiusGradientBlur(40, {
        fractionStops: [[1, 0], [0, 1]],
        direction: GradientDirection.Bottom
      });
    } catch (e) {
      log.showError(`get HeadBlurArea radiusGradientBlur failed, err: ${e}`);
      return undefined;
    }
  }

  @Monitor('isLandscapeLayout')
  public onIsLandscapeLayoutChange(): void {
    if (this.isLandscapeLayout) {
      this.layoutOptions = {
        direction: FlexDirection.Row,
        alignItems: ItemAlign.Center,
      }
      this.blurAreaHeight = BLUR_AREA_HEIGHT_LANDSCAPE_LAYOUT;
    } else {
      this.layoutOptions = {
        direction: FlexDirection.Column,
        alignItems: ItemAlign.Center,
      }
      this.blurAreaHeight = BLUR_AREA_HEIGHT;
    }
    this.emitter.emit('isLandscapeLayout', this.isLandscapeLayout);
    log.showInfo(`isLandscapeLayout changed ${this.isLandscapeLayout}`);
  }

  private reportPanelHide(dropDownEvent: DropDownEvent): void {
    if (dropDownEvent.target !== TargetPanel.NONE || !this.listScrollerVm) {
      return;
    }
    if (this.lastTarget === TargetPanel.NOTIFICATION_PANEL) {
      const dropDownCount = Math.floor(this.listScrollerVm.maxDropDownDis / this.calculateNtfListHeight());
      const params: NotificationPanelSlideParams = {
        TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
        SLIDE_DISTANCE: dropDownCount < 3 ? dropDownCount : 3
      }
      NotificationSysEventReporter.notificationPanelSlide(params);
    }
    if (this.lastTarget !== TargetPanel.NONE) {
      this.listScrollerVm.maxDropDownDis = 0;
    }
  }

  private calculateNtfListHeight(): number {
    const phoneNtfCenterTitleHeight =
      ResUtils.getNumberFromLength(this.isLandscapeLayout ? $r('app.float.ntf_center_header_phone_land_height') :
      $r('app.float.ntf_center_header_phone_height'));
    const statusBarHeight = ResUtils.getNumberFromLength($r('app.float.status_bar_setting_status_bar_height'));
    return ArkUIAdapter.px2vp(DeviceInfoVm.instance.height) - phoneNtfCenterTitleHeight - statusBarHeight;
  }

  private async hideDropdownPanle(): Promise<void> {
    // 如果收起通知中心面板但面板窗口未隐藏则隐藏窗口
    if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NONE &&
      await ViewManagerAdapter.isViewShowing(ViewType.DROPDOWN)) {
      ViewManagerAdapter.hideView(ViewType.DROPDOWN);
      log.showInfo('Dropdown panel is not hided, hide the dropdown panel.');
    }
  }
}