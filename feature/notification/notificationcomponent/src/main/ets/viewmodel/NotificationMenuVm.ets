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

import { notificationCcmConfig, NotificationCreatorType, NotificationSysEventReporter } from '@ohos/systemuicommon';
import {
  AnimationBase,
  DeviceInfoVm,
  INotificationMenuVm,
  LiveNotification,
  NotificationItemBaseVm,
  RemoveButtonData,
  ResourceVm,
  SettingButtonData,
  DropDownPanelManager
} from '@ohos/systemuicommon/newIndex';
import Curves from '@ohos.curves';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationStyle } from '../constants/NotificationStyle';
import { LogDomain, LogHelper, DomainName, TraceUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'NotificationMenuVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

const MENU_VIEW_TAG = 'NotificationMenuView';

@ObservedV2
export class NotificationMenuVm extends NotificationItemBaseVm implements INotificationMenuVm {
  /**
   * 设置按钮横向偏移量相对滑动距离的比率
   */
  private static readonly SETTING_BUTTON_OFFSET_RATIO: number = 12.0 / 7.0;
  /**
   *  删除按钮横向偏移量相对滑动距离的比率
   */
  private static readonly REMOVE_BUTTON_OFFSET_RATIO: number = 2.0;

  /**
   * 垃圾桶盖最大旋转角度
   */
  private static readonly BIN_COVER_FIRST_GEAR_MAX_ANGLE: number = 12.0;
  /**
   * 垃圾桶身旋转角度
   */
  private static readonly BIN_BODY_SECOND_GEAR_MAX_ANGLE: number = -10.0;

  /**
   * 删除通知时按钮往左横滑距离
   */
  private static readonly REMOVE_ITEM_TRAN_X = 50;

  /**
   * 删除按钮缩放系数
   */
  private static readonly REMOVE_BUTTON_SCALE_RATIO: number = 0.05;
  /**
   * 删除按钮动效参数
   */
  private static readonly REMOVE_BUTTON_ANIMATE: AnimateParam = {
    curve: Curves.springCurve(0, 1, 228, 23),
    onFinish: () => TraceUtil.endTrace(DomainName.NC, 'ClearSingleNtAni'),
  };

  private static readonly SETTING_BUTTON_ANIMATE: AnimateParam = {
    duration: 30,
  };

  /**
   * 是否横滑到了删除通知项的阈值
   */
  public isSwipeOverThreshold: boolean = false;

  /**
   * 删除按钮参数
   */
  public removeButtonData: RemoveButtonData = new RemoveButtonData();

  /**
   * 设置按钮参数
   */
  public settingButtonData: SettingButtonData = new SettingButtonData();

  /**
   * 通知点击删除按钮删除
   */
  private isClickButtonRemoving = false;

  /**
   * 是否在组通知里
   */
  @Trace public isInGroup = false;
  private offsetX: number = 0;

  /**
   * 按钮宽度
   *
   * @returns 按钮宽度
   */
  @Computed get menuWidth(): number {
    const singleMenuWidth = NotificationStyle.ITEM_PADDING * 2 + NotificationStyle.ITEM_ICON_SIZE;
    let menuWidth = 0;
    if (this.isShowSettingButton()) {
      menuWidth += singleMenuWidth;
    }
    if (this.isShowRemoveButton()) {
      menuWidth += singleMenuWidth;
    }
    return menuWidth;
  }

  @Monitor('ntf.appLabel')
  onNtfAppLabelChange() {
    const settingDialogVm = this.vmInjector.getSettingDiagVm();
    if (settingDialogVm?.settingDiagData?.isShowDialog && settingDialogVm?.ntf?.hashCode === this.ntf?.hashCode) {
      log.showInfo(`onNtfAppLabelChange ntf ${this.ntf?.hashCode}`);
      settingDialogVm.setDialogTitle();
    }
  }

  public isMenuExpanded(): boolean {
    log.showInfo(`offsetX ${this.offsetX}, width: ${this.menuWidth}`);
    if (this.menuWidth === 0) {
      return false;
    }
    return -this.offsetX >= this.menuWidth;
  }

  public isShowSettingButton(): boolean {
    log.showInfo(`is show setting, ntf ${this.ntf?.hashCode}, inInGroup ${this.isInGroup}`);
    // 组通知中的子通知不显示
    if (this.isInGroup) {
      return false;
    }
    // 组通知必须要所有子项都显示设置按钮，组通知才会显示设置按钮
    if (this.ntf?.isNormalGroup()) {
      return this.ntf.children.every((c) => this.checkShowSettingButton(c));
    }
    return this.checkShowSettingButton(this.ntf!);
  }

  private checkShowSettingButton(ntf: NotificationBase): boolean {
    if (ntf instanceof LiveNotification) {
      // 模板通知转实况不支持设置
      if (ntf.isConvertFromNormal) {
        return false;
      }
      // 配置为不显示不支持设置
      if (this.isHideSwitch(ntf)) {
        return false;
      }
      // 系统实况不支持设置
      if (ntf.card?.isSystemCard()) {
        return false;
      }
    }
    // SA发送的不支持设置
    if (ntf.creatorType === NotificationCreatorType.SA) {
      return false;
    }
    // 紧急模式下不支持设置
    if (DeviceInfoVm.instance.isEmergencyMode()) {
      return false;
    }
    // 折叠态更多通知不支持设置
    if (this.isMoreBrief()) {
      return false;
    }
    // 全场景通知不支持设置
    if (this.ntf.isCollaNotification) {
      return false;
    }

    return !ntf.isSettingIgnore;
  }

  private isHideSwitch(ntf: LiveNotification): boolean {
    // 应用代理发送时，使用代理者的包名判断权限，否则使用应用自己的包名
    const bundleName = ntf.agentBundle?.bundle ?? ntf.creatorBundleName;
    return notificationCcmConfig.isHiddenSwitch(bundleName);
  }

  public isShowRemoveButton(): boolean {
    if (this.ntf?.isNormalGroup()) {
      return this.ntf.children.every((c) => c.isRemoveAllowed);
    }
    return this.ntf!.isRemoveAllowed;
  }

  public updateSwipeOffsetX(swipeOffsetX: number, isSwipeRemoving: boolean): void {
    this.offsetX = swipeOffsetX;
    // 向右滑动和正在删除时不处理
    if (swipeOffsetX > 0 || this.isClickButtonRemoving) {
      return;
    }
    const overMenuOffsetX = -swipeOffsetX - this.menuWidth;
    this.isSwipeOverThreshold = (overMenuOffsetX >= this.getRemoveOffsetXThreshold() && this.isShowRemoveButton());
    this.setSettingButton(swipeOffsetX, isSwipeRemoving);
    this.setRemoveButton(swipeOffsetX, overMenuOffsetX, isSwipeRemoving);
  }

  /**
   * 设置按钮点击事件
   */
  onSettingButtonClick(): void {
    if (this.vmInjector.getListScrollerVm()?.isScrolling) {
      log.showInfo('The list is scrolling, and the settings button is not allowed to be clicked.')
      return;
    }
    this.reportSettingButton();
    const buttonRect = ItemUtils.getRectById(this.vmInjector.getId(`${MENU_VIEW_TAG}_setting_${this.ntf.hashCode}`));
    const translateY = this.vmInjector.getCardVm(this.ntf)?.translateY ?? 0;
    const left = ResourceVm.instance.isRTL ?
      ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - buttonRect.left - (buttonRect?.width ?? 0) : buttonRect.left;
    this.vmInjector.getSettingDiagVm()?.openSetting(this.ntf,
      {
        x: left,
        y: buttonRect.top + translateY,
      });
  }

  /**
   * 点击设置按钮打点
   */
  private reportSettingButton() {
    NotificationSysEventReporter.notificationPanelSlipSetting({
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      TIME_STAMP: this.ntf.slotLevel !== 3 ? `${DropDownPanelManager.getLastDropdownTime()}` : undefined,
      NOTIFICATION_ID: this.ntf?.id,
      BUNDLE_TYPE: this.ntf?.bundleType,
      TRACE_ID: this.ntf?.traceId,
    });
  }

  private setSettingButton(swipeOffsetX: number, isSwipeRemoving: boolean): void {
    if (this.isSwipeOverThreshold || isSwipeRemoving) {
      if (this.settingButtonData.opacity && this.ntf.isClearAllowed && !this.ntf.isOngoing) {
        new AnimationBase(AnimationBase.NAMES.NTF_MENU_ANIMATION, true).executeAnimation([{
          duration: 50, curve: Curve.Friction, event: () => this.settingButtonData.opacity = 0
        }])
      }
    } else {
      this.settingButtonData.opacity = Math.min(1, -swipeOffsetX / this.menuWidth);
    }

    if (-swipeOffsetX <= this.menuWidth) {
      this.settingButtonData.offsetX = 0;
    } else {
      this.settingButtonData.offsetX = (this.menuWidth + swipeOffsetX) / NotificationMenuVm.SETTING_BUTTON_OFFSET_RATIO;
    }
  }

  private setRemoveButton(swipeOffsetX: number, overMenuOffsetX: number, isSwipeRemoving: boolean): void {
    this.removeButtonData.opacity = isSwipeRemoving ? 0 : Math.min(1, -swipeOffsetX / this.menuWidth);
    // 滑动距离超过菜单宽度
    if (overMenuOffsetX >= 0 && !this.isMoreBrief()) {
      this.setButtonOffsetAndScale(swipeOffsetX, overMenuOffsetX);
      this.animationOverThreshold(overMenuOffsetX);
    }
  }

  /**
   * 设置按钮偏移和缩放
   * @param swipeOffsetX
   * @param overMenuOffsetX
   */
  private setButtonOffsetAndScale(swipeOffsetX: number, overMenuOffsetX: number) {
    this.removeButtonData.offsetX = (this.menuWidth + swipeOffsetX) / NotificationMenuVm.REMOVE_BUTTON_OFFSET_RATIO;
    const ratio = Math.min(overMenuOffsetX / this.getRemoveOffsetXThreshold(), 1);
    this.removeButtonData.scale = 1 + (ratio * NotificationMenuVm.REMOVE_BUTTON_SCALE_RATIO);
  }

  /**
   * 超过阈值后的动效
   * @param overMenuOffsetX
   */
  private animationOverThreshold(overMenuOffsetX: number): void {
    if (!this.ntf.isRemoveAllowed || this.ntf.isOngoing) {
      return;
    }
    // 垃圾桶盖旋转，以右端点为圆心旋转
    this.removeButtonData.coverRotate = Math.min(overMenuOffsetX / this.getRemoveOffsetXThreshold(), 1) *
    NotificationMenuVm.BIN_COVER_FIRST_GEAR_MAX_ANGLE;
    // 垃圾桶身动画
    if (this.isSwipeOverThreshold && this.removeButtonData.expandScale === 0) {
      const buttonWidth =
        ResUtils.getNumberFromLength($r('app.float.ntf_item_right_icon_size')) * this.removeButtonData.scale / 2;
      const expandOffsetX = -buttonWidth - ResUtils.getNumberFromLength($r('app.float.ntf_extra_content_width'));
      this.doAnimation(expandOffsetX, NotificationMenuVm.REMOVE_BUTTON_SCALE_RATIO,
        NotificationMenuVm.BIN_BODY_SECOND_GEAR_MAX_ANGLE);
      return;
    }
    if (!this.isSwipeOverThreshold && this.removeButtonData.expandScale !== 0) {
      this.doAnimation(0, 0, 0);
    }
  }

  private doAnimation(expandOffsetX: number, expandScale: number, binRotate: number): void {
    new AnimationBase(AnimationBase.NAMES.NTF_MENU_ANIMATION, true).executeAnimation([{
      duration: 200,
      curve: Curve.Friction,
      event: () => {
        this.removeButtonData.expandOffsetX = expandOffsetX;
        this.removeButtonData.expandScale = expandScale;
        // 垃圾桶身旋转，以右上角为圆心旋转
        this.removeButtonData.binRotate = binRotate;
      }
    }])
  }

  public removeNtf(offsetX?: number): void {
    this.reportClickDeleteMenu();
    log.showInfo(`Remove ntf for ${this.ntf?.hashCode}`);
    TraceUtil.startTrace(DomainName.NC, 'ClearSingleNtAni');
    this.isClickButtonRemoving = true;

    animateTo(NotificationMenuVm.SETTING_BUTTON_ANIMATE, () => {
      this.settingButtonData.opacity = 0;
    })

    animateTo(NotificationMenuVm.REMOVE_BUTTON_ANIMATE, () => {
      this.removeButtonData.opacity = 0;
      this.removeButtonData.offsetX = -this.menuWidth - NotificationMenuVm.REMOVE_ITEM_TRAN_X;
    })
  }

  /**
   * 点击删除按钮打点
   */
  private reportClickDeleteMenu() {
    NotificationSysEventReporter.notificationPanelSlipLeftDelete({
      DISPLAY_SCENE:  4,
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      NOTIFICATION_ID: this.ntf?.id,
      NOTIFICATION_SLOT_TYPE:  this.ntf?.slotType,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      IS_GROUP: this.ntf?.isNormalGroup() ? 1 : this.isInGroup ? 2 : 0,
      NOTIFICATION_CONTROL_FLAGS: this.ntf?.controlConfig?.flags,
      TRACE_ID: this.ntf?.traceId
    });
  }

  protected  getRemoveOffsetXThreshold(): number {
    return DeviceInfoVm.instance.isLandscape ? 220 : 100;
  }

  private isMoreBrief(): boolean {
    const isCollapsed = this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed ?? false;
    return this.ntf.isMoreNtf() && isCollapsed;
  }
}