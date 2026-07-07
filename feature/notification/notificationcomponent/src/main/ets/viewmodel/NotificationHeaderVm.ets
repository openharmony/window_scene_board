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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper, EvtBus,
  obtainLocalEvent, EventConstants,
  sEventManager, TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { OperatorClockChangeEvent } from '@ohos/systemuicommon';
import {
  CellularDataVm,
  CutoutPosition,
  CutoutVm,
  DropdownVm, INotificationHeaderVm, NotificationBaseVm,
  ResourceVm } from '@ohos/systemuicommon/newIndex';
import { sharedData } from '@ohos/systemuicommon/src/main/ets/model/SendableData';
import { CutoutLayout } from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationClearButtonVm';
import { DISABLE_HEAD_BLUR_EFFECT } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { ResUtils } from '@ohos/windowscene';
import { NotificationHeaderAnimation } from '../animation/NotificationHeaderAnimation';
import { NotificationStyle } from '../constants/NotificationStyle';
import { NotificationClearButtonVm } from './NotificationClearButtonVm';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationHeaderVm');

/**
 * 横屏右侧有孔时，孔与一键删除按钮间隔
 */
const CUTOUT_EXTEND_PADDING = 4;
/**
 * 横屏右侧有孔时，一键删除按钮与通知列表间隔
 */
const CUTOUT_CLEAR_BUTTON_LEFT_PADDING = 16;

/**
 * 通知中心面板头部管理
 *
 * @since 2024-11-08
 */
@ObservedV2
export class NotificationHeaderVm extends NotificationBaseVm implements INotificationHeaderVm {
  private cutoutVm = CutoutVm.instance;
  private resourceVm: ResourceVm = ResourceVm.instance;
  /**
   * 时间透明度
   */
  @Trace public timeTextOpacity: number = 0;
  /**
   * 时间缩放属性
   */
  @Trace public timeTextScale: number = 1;
  /**
   * 时间位移
   */
  @Trace public timeTextTranslateY: number = 0;
  /**
   * 日期透明度
   */
  @Trace public dateTextOpacity: number = 0;
  /**
   * 日期缩放
   */
  @Trace public dateTextScale: number = 1;
  /**
   * 日期位移
   */
  @Trace public dateTextTranslateY: number = 0;
  /**
   * 下拉跟手动效
   */
  @Trace public followAnim?: AnimateParam;
  /**
   * 通知中心面板位移
   */
  @Trace public headerTranslateY: number = 0;

  /**
   * 通知Header组件高度
   */
  @Trace public headerHeight: number = 0;
  /**
   * 前一次下拉面板距离
   */
  public preDropDownMoveY: number = 0;
  /**
   * 动效管理
   */
  private headerAnimation: NotificationHeaderAnimation = new NotificationHeaderAnimation();
  private preTimeTransY: number = 0;

  @Trace public width = '100%';
  @Trace public timeTextFontSize = this.getTimeTextFontSize();
  public timeTextFontWeight = FontWeight.Bold
  @Trace public timeTextLineHeight: Resource | undefined = undefined;
  @Trace public dateTextFontSize = this.getDateTextFontSize();
  @Trace public dateTextFontWeight = FontWeight.Regular;
  @Trace public dateTextLineHeight: Resource | undefined = undefined;
  @Trace public alignRules: LocalizedAlignRuleOptions = { top: { anchor: '__container__', align: VerticalAlign.Top } };
  public margin: Margin = { top: $r('app.float.status_bar_phone_height') };
  /**
   * 运营商是否切换为时间
   */
  private isOperatorChange: boolean = false;
  /**
   * 前一次第一张卡片的位移
   */
  private preFirstCardTransY: number = 0;

  @Computed get visibility(): Visibility {
    return Visibility.Visible;
  }

  @Computed get cutoutPosition(): CutoutPosition {
    return this.cutoutVm.position;
  }

  @Monitor('cutoutPosition')
  onCutoutPositionChanged(): void {
    this.isLandscapeLayoutChange(this.vmInjector.getPanelVm().isLandscapeLayout);
  }

  public registerEventListener(): void {
    this.vmInjector.getPanelVm().emitter?.on('isLandscapeLayout', this.isLandscapeLayoutChange);
  }

  public unRegisterEventListener(): void {
    this.vmInjector.getPanelVm().emitter?.off('isLandscapeLayout', this.isLandscapeLayoutChange);
  }

  showTitleText(): void {
    this.timeTextOpacity = 1;
    this.timeTextScale = NotificationHeaderAnimation.timeShowScale;
    this.timeTextTranslateY = 0;
    this.dateTextOpacity = 1;
    this.dateTextScale = NotificationHeaderAnimation.dateShowScale;
    this.dateTextTranslateY = 0;
  }

  doTitleAnim(isShow: boolean): void {
    if (isShow) {
      this.headerAnimation.doShowAnim(this);
    } else if (DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      this.headerAnimation.doHideAnim(this);
    }
  }

  /**
   * 下拉跟手更新纵向位移
   * @param transY 位移
   */
  followUpdateTransY(transY: number) {
    // 滚动过程中时，不更新下拉位移参数
    if (!DropdownVm.instance.isNeedUpdateMoveY || !this.vmInjector.getPanelVm().isVisible) {
      return;
    }

    if (!this.followAnim) {
      this.followAnim = {
        duration: 500,
        curve: Curve.Friction,
      }
    }

    this.headerTranslateY = transY;
  }

  public portraitGetPanGestureHandler(): PanGestureHandler {
    return new PanGestureHandler({ direction: PanDirection.Horizontal })
      .onActionStart((event: GestureEvent) => DropdownVm.instance.onPanHorizontalStart(event))
      .onActionUpdate((event: GestureEvent) => DropdownVm.instance.onPanHorizontalUpdate(event))
      .onActionEnd((event: GestureEvent) => DropdownVm.instance.onPanHorizontalEnd(event))
  }

  public getPanGestureHandler(): PanGestureHandler {
    return this.vmInjector.getPanelVm().isLandscapeLayout ? this.landscapeGetPanGestureHandler() :
    this.portraitGetPanGestureHandler();
  }


  public portraitDoFollowUpdateTransY(transY: number, dropDownMoveY: number): void {
    if (this.preTimeTransY === transY) {
      return;
    }
    if ((dropDownMoveY === 0 && this.preDropDownMoveY === 0) || this.preDropDownMoveY < 0) {
      this.followAnim = undefined
    } else {
      this.followAnim = { duration: 500, curve: Curve.Friction, }
    }
    this.timeTextTranslateY = transY;
    this.dateTextTranslateY = transY;
    this.preTimeTransY = transY;
    this.preDropDownMoveY = dropDownMoveY;
  }

  public doFollowUpdateTransY(transY: number, dropDownMoveY: number): void {
    if (this.vmInjector.getPanelVm().isLandscapeLayout) {
      this.landscapeDoFollowUpdateTransY(transY, dropDownMoveY);
    } else {
      this.portraitDoFollowUpdateTransY(transY, dropDownMoveY);
    }
  }

  public showBlurAndClockWhenFollowHand(): void {
    if (!this.vmInjector.getPanelVm().isLandscapeLayout &&
      DropdownVm.instance.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      this.updateStatusBarVisible();
      // 运营商切换
      this.updateClockStatus();
      // 模糊
      this.vmInjector.getPanelVm().isBlurAreaVisible = DISABLE_HEAD_BLUR_EFFECT ? false : this.timeTextOpacity <= 0;
    }
  }

  public resetFollowHandAnim(): void {
    this.preFirstCardTransY = 0;
  }

  public resetClockStatus(): void {
    if (this.isOperatorChange) {
      EvtBus.post(OperatorClockChangeEvent, new OperatorClockChangeEvent(false));
      this.isOperatorChange = false;
    }
  }
  public portraitDoFollowHandAnim(firstCardTransY: number, widthAnim?: boolean): void {
    if (DropdownVm.instance.dropdownEvent.target !== TargetPanel.NOTIFICATION_PANEL) {
      return;
    }
    if (!this.checkShouldDoFollowHandAnim(firstCardTransY)) {
      return;
    }
    this.followAnim = undefined;
    // 执行跟手动效
    const isExtraNtfsCollapsing = this.vmInjector.getMoreVm()?.isExtraNtfsCollapseStatusChanging &&
      this.vmInjector.getNotificationMoreHeaderVm()?.isButtonCollapsed;
    if (isExtraNtfsCollapsing) {
      animateTo({ curve: Curve.Friction, duration: 350 }, () => this.portraitDoFollowHand(firstCardTransY, widthAnim));
    } else {
      this.portraitDoFollowHand(firstCardTransY, widthAnim);
    }
  }

  public doFollowHandAnim(firstCardTransY: number, widthAnim?: boolean): void {
    if (this.vmInjector.getPanelVm().isLandscapeLayout) {
      this.landscapeDoFollowHandAnim(firstCardTransY);
    } else {
      this.portraitDoFollowHandAnim(firstCardTransY, widthAnim);
    }
  }

  private checkShouldDoFollowHandAnim(firstCardTransY: number): boolean {
    if (firstCardTransY === this.preFirstCardTransY) {
      return false;
    }
    let checkRes = true;
    // 当时间组件消失后，再往上滑动不再执行动效;当时间组件完全出现后，再往下滑动不再执行动效
    const checkScrollUp =
      firstCardTransY < this.preFirstCardTransY && this.dateTextOpacity <= 0 && this.timeTextOpacity <= 0;
    const checkScrollDown =
      firstCardTransY > this.preFirstCardTransY && this.dateTextOpacity >= 1 && this.timeTextOpacity >= 1
    if (checkScrollUp || checkScrollDown) {
      checkRes = false;
    }
    this.preFirstCardTransY = firstCardTransY;
    return checkRes;
  }

  private portraitDoFollowHand(firstCardTransY: number, widthAnim?: boolean): void {
    // 日期位移距离：日期与第一张卡片的距离+0.5倍日期高度
    const dateTranY =
      ResUtils.getNumber($r('app.float.ntf_title_padding_bottom')) + ResUtils.getNumber(this.dateTextFontSize) / 2;
    this.doDateFollowHandAnim(firstCardTransY, dateTranY);
    this.doTimeFollowHandAnim(firstCardTransY, dateTranY);
    if (!widthAnim) {
      this.showBlurAndClockWhenFollowHand();
    }
  }

  private doDateFollowHandAnim(firstCardTransY: number, dateTranY: number): void {
    if (firstCardTransY < 0) {
      this.dateTextScale = Math.max(0.2, 1 + (0.8 / dateTranY * firstCardTransY));
      this.dateTextOpacity = Math.max(0, 1 + (1 / dateTranY * firstCardTransY));
    } else {
      this.dateTextScale = 1;
      this.dateTextOpacity = 1;
    }
  }
  private doTimeFollowHandAnim(firstCardTransY: number, dateTranY: number): void {
    // 时间位移距离：日期与第一张卡片的距离+日期高度+日期与时间的距离+0.75倍时间高度
    const timeTranY = dateTranY + ResUtils.getNumber(this.dateTextFontSize) / 2 +
    ResUtils.getNumber($r('app.float.ntf_title_date_margin_top')) + ResUtils.getNumber(this.timeTextFontSize) * 0.75;
    // 从日期透明度到0.4开始执行缩放动效
    const timeScaleStartTranY = 0.6 * dateTranY;
    const timeScaleTranY = timeTranY - timeScaleStartTranY;
    if (firstCardTransY < -timeScaleStartTranY) {
      // 缩放从1.25变到0.25
      this.timeTextScale = Math.max(0.25,
        NotificationHeaderAnimation.timeShowScale + (1 / timeScaleTranY * (firstCardTransY + timeScaleStartTranY)));
    } else {
      this.timeTextScale = NotificationHeaderAnimation.timeShowScale;
    }
    // 从时间缩小到0.75开始执行透明度动效
    const timeOpacityStartTranY = 0.5 * timeScaleTranY + timeScaleStartTranY;
    const timeOpacityTranY = timeTranY - timeOpacityStartTranY;
    if (firstCardTransY < -timeOpacityStartTranY) {
      this.timeTextOpacity = Math.max(0, 1 + (1 / timeOpacityTranY * (firstCardTransY + timeOpacityStartTranY)));
    } else { this.timeTextOpacity = 1; }
  }

  /**
   * 通知中心列表上滑隐藏状态栏
   */
  private updateStatusBarVisible(): void {
    if (this.timeTextOpacity === 0) {
      animateTo({
        duration: 350,
        curve: Curve.Friction
      }, () => {
        sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, false));
      })
      return;
    }
    if (this.timeTextOpacity > 0 && DropdownVm.instance.isDropDown) {
      animateTo({
        duration: 50,
        curve: Curve.Friction
      }, () => {
        sEventManager.publish(obtainLocalEvent(EventConstants.CONTROL_CENTER_SHOW_HIDE_BAR, true));
      })
    }
  }

  private updateClockStatus(): void {
    if (this.timeTextOpacity <= 0.4 && !this.isOperatorChange) {
      EvtBus.post(OperatorClockChangeEvent, new OperatorClockChangeEvent(true));
      this.isOperatorChange = true;
      return;
    }
    if (this.timeTextOpacity > 0.4 && this.isOperatorChange && DropdownVm.instance.isDropDown) {
      EvtBus.post(OperatorClockChangeEvent, new OperatorClockChangeEvent(false));
      this.isOperatorChange = false;
    }
  }
  private getTimeTextFontSize(): Resource {
    return DeviceHelper.isPad() ? $r('app.float.ntf_title_pad_time_font_size') :
    $r('app.float.ntf_title_time_font_size');
  }
  private getDateTextFontSize(): Resource {
    return DeviceHelper.isPad() ? $r('app.float.ntf_title_pad_date_font_size') :
    $r('app.float.ntf_title_date_font_size');
  }

  public isLandscapeLayoutChange = (isLandscapeLayout: boolean): void => {
    const cutoutLayout = this.calcCutoutLayout(isLandscapeLayout);
    if (isLandscapeLayout) {
      // 横屏布局如果需要避让,则使用避让修正宽度
      this.width = cutoutLayout ? CommonUtils.spliceVp(cutoutLayout.headerWidth) :
        NotificationStyle.LANDSCAPE_HEAD_VIEW_WIDTH;

      this.headerTranslateY = 0;
      this.timeTextFontSize = $r('app.float.ntf_title_time_land_font_size');
      this.timeTextLineHeight = $r('app.float.ntf_title_time_land_line_height');
      this.dateTextFontSize = $r('app.float.ntf_title_date_land_font_size');
      this.dateTextFontWeight = FontWeight.Regular;
      this.dateTextLineHeight = $r('app.float.ntf_title_date_land_line_height');
      this.alignRules = {
        start: { anchor: '__container__', align: HorizontalAlign.Start },
        center: { anchor: '__container__', align: VerticalAlign.Center }
      };
    } else {
      this.width = '100%';

      this.headerTranslateY = 0;
      this.timeTextFontSize = this.getTimeTextFontSize();
      this.timeTextLineHeight = undefined;
      this.dateTextFontSize = this.getDateTextFontSize();
      this.dateTextFontWeight = FontWeight.Regular;
      this.dateTextLineHeight = undefined;
      this.alignRules = { top: { anchor: '__container__', align: VerticalAlign.Top } };
    }
    // 设置一键清除按钮的避让布局信息
    this.vmInjector.getClearButtonVm()?.setCutoutLayout(cutoutLayout);
  }

  private landscapeGestureActionEnd(event: GestureEvent): void {
    if (Math.abs(event.offsetX) > Math.abs(event.offsetY)) {
      log.showInfo(`onHorizontal, hidePanel`);
      DropdownVm.instance.hidePanel(true);
      return;
    }
    DropdownVm.instance.onPanVerticalEnd();
  }

  public landscapeGetPanGestureHandler(): PanGestureHandler {
    return new PanGestureHandler({ direction: PanDirection.Vertical })
      .onActionStart((event: GestureEvent) => DropdownVm.instance.onPanVertical(event))
      .onActionUpdate((event: GestureEvent) => DropdownVm.instance.onPanVertical(event))
      .onActionEnd((event: GestureEvent) => this.landscapeGestureActionEnd(event))
  }

  public landscapeDoFollowHandAnim(firstCardTransY: number): void {
    this.vmInjector.getPanelVm().isBlurAreaVisible = DISABLE_HEAD_BLUR_EFFECT ? false : firstCardTransY < 0;
  }

  public landscapeDoFollowUpdateTransY(transY: number, dropDownMoveY: number): void {
    return;
  }

  /**
   * 计算通知中心挖孔布局信息
   * @param isLandscapeLayout
   */
  private calcCutoutLayout(isLandscapeLayout: boolean): CutoutLayout | undefined {
    // 非横屏模式布局直接返回
    if (!isLandscapeLayout) {
      return undefined;
    }

    const btnWidth: number = ResUtils.getNumber($r('app.float.ntf_clear_button_icon_size'));
    // 一键删除按钮原始宽度
    const originWidth = ArkUIAdapter.px2vp(this.cutoutVm.displayWidth) *
      (1 - NotificationStyle.LANDSCAPE_LIST_WIDTH_RATE) - NotificationStyle.LANDSCAPE_HEAD_VIEW_WIDTH_NUM;

    let cutoutHeight = 0;
    // 计算挖孔高度（包含孔与边框距离）
    if (this.cutoutVm.rect && this.resourceVm.isRTL && this.cutoutVm.position === CutoutPosition.LEFT) {
      // 镜像语言且挖孔在左侧
      cutoutHeight = this.cutoutVm.rect.left + this.cutoutVm.rect.width;
    } else if (this.cutoutVm.rect && !this.resourceVm.isRTL && this.cutoutVm.position === CutoutPosition.RIGHT) {
      // 非镜像语言且挖孔在右侧
      cutoutHeight = ArkUIAdapter.px2vp(this.cutoutVm.displayWidth) - this.cutoutVm.rect.left;
    }

    // 未获取到孔高度
    if (cutoutHeight <= 0) {
      return undefined;
    }

    // 计算通知列表右侧宽度 = 挖孔到屏幕高度 + 孔与按钮间距 + 按钮宽度 + 按钮与通知列表间距
    const needTotalWidth: number = cutoutHeight + CUTOUT_EXTEND_PADDING + btnWidth + CUTOUT_CLEAR_BUTTON_LEFT_PADDING;
    // 计算删除按钮容器marginEnd = 通知列表右侧宽度 - 删除按钮容器宽度
    const clearBtnMarginEnd = cutoutHeight + CUTOUT_EXTEND_PADDING;
    // 使用原始宽度进行居中显示与孔之间距离是否满足条件, 若满足则直接使用原始值
    if ((originWidth - btnWidth) / 2 - cutoutHeight >= CUTOUT_EXTEND_PADDING) {
      return undefined;
    }

    // 右侧所需宽度是否大于原始宽度, 若大于则header需要进行宽度修正, 反之则不需要修正
    const widthDiff = needTotalWidth > originWidth ? needTotalWidth - originWidth : 0;
    log.showInfo(`calcCutoutLayout isRTL: ${this.resourceVm.isRTL} cutoutHeight: ${cutoutHeight} \
needTotalWidth: ${needTotalWidth} clearBtnWidth: ${btnWidth} clearBtnMarginEnd: ${clearBtnMarginEnd}`);
    return {
      cutoutHeight: cutoutHeight,
      headerWidth: NotificationStyle.LANDSCAPE_HEAD_VIEW_WIDTH_NUM - widthDiff,
      clearBtnWidth: btnWidth,
      clearBtnMarginEnd: clearBtnMarginEnd,
    }
  }
}