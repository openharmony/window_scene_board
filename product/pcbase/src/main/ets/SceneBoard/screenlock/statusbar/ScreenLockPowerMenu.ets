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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, sSettingsUtil } from '@ohos/frameworkwrapper';
import PowerViewModel, { PowerMenuType} from './PowerViewModel';
import { KeyCode } from '@kit.InputKit';
import StyleConfiguration, { ClickableMenuStyle,
  CommonComponentStyle, SystemPanelComponentStyle } from '../common/StyleConfiguration';
import PowerDialog from './PowerDialog';
import Constants from '../common/Constants'
import { NormalPanelInfo } from '../../../common/manager/StatusBarPanelManager';
import mModel from '../../systempanel/model/SystemPanelModel';
import {
  LogoutConfirmVM,
  PowerOffConfirmBuilder
} from '../../userspanel/component/LogoutConfirmDialog/LogoutConfirm/LogoutConfirm';
import mSystemPanelModel from '../../systempanel/model/SystemPanelModel';
import { SCBCustomDialogWrapper } from '../../../common/SCBCustomDialogWrapper';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { SlPowerPanelListInfo } from './ViewModel/SlPowerPanelViewModel';

const TAG = 'ScreenLock-PowerMenu';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COMPONENT_ID_CONTENT = TAG + '_Text_content';
const KEY = 'h1_systemUI_product_pc_ScreenLock_PowerMenu_';
const IS_HIBERNATE_OPEN = '1'; //hibernate开关打开时的值
const HIBERNATE_KEY = 'settings.power.hibernate_flag'; //hibernate开关在数据库的key
const HWF_SHUTDOWN_ALLOWED = 'hwf.shutdown.allowed';

@Component
export default struct ScreenLockPowerMenu {
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State style: SystemPanelComponentStyle = StyleConfiguration.getSystemPanelComponentStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @Link globalClickable: boolean;
  @State backgroundClr: ResourceColor = this.styleClickable.stackBgColorUnSelected;
  @Link panelInfo: NormalPanelInfo | undefined;
  @Link dialogOffset: Offset;
  @State isVirtualMachineUpdating: boolean = false;

  private clickable: boolean = true;
  private powerType: PowerMenuType | undefined = undefined;
  private textContent?: Resource | null = undefined;
  private dialogMsg: Resource | undefined = undefined;
  private mTimeMeter: number = 0;
  private mInterval: number = 500;
  private mLastActionTime: number = 0;
  private mIsRunning: boolean = false;
  private mTimeMeterOfPowerMenu: number = 0;
  private onDialogShow: () => void = () => {};
  private onDialogCancel: () => void = () => {};
  private shutdownFlage: boolean = true;

  /**
   * @description 构建弹窗对象
   */
  private shutDownVm: LogoutConfirmVM = new LogoutConfirmVM(
    {
      title: $r('app.string.shutdown_device'),
      content: $r('app.string.multiuser_confirm_shutdown_tip'),
      isLoginUserListVisible: true,
      cancelText: $r('app.string.common_cancel'),
      onCancel: () => {
        this.shutdownDialogController.closeDialog();
        this.onDialogCancel();
      },
      confirmText: $r('app.string.shutdown_device'),
      onConfirm: () => {
        if (this.powerType !== undefined) {
          PowerViewModel.handlePowerMenuClick(this.powerType);
        } else {
          log.showInfo('powertype is undefined');
        }
      }
    }
  );

  private rebootVm: LogoutConfirmVM = new LogoutConfirmVM(
    {
      title: $r('app.string.multiuser_dialog_reboot'),
      content: $r('app.string.multiuser_confirm_reboot_tip'),
      isLoginUserListVisible: true,
      cancelText: $r('app.string.common_cancel'),
      onCancel: () => {
        this.rebootDialogController.closeDialog();
        this.onDialogCancel();
      },
      confirmText: $r('app.string.multiuser_dialog_reboot'),
      onConfirm: () => {
        if (this.powerType !== undefined) {
          PowerViewModel.handlePowerMenuClick(this.powerType);
        } else {
          log.showInfo(`powerType is undefined`);
        }
      }
    }
  );

  private shutdownDialogExpandController: CustomDialogController = new CustomDialogController({
    builder: PowerOffConfirmBuilder({
      vm: this.shutDownVm
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  });

  private shutdownDialogFoldController: CustomDialogController | null =
    DeviceHelper.isSuperFoldMachine() ? new CustomDialogController({
      builder: PowerOffConfirmBuilder({
        vm: this.shutDownVm
      }),
      autoCancel: false,
      alignment: DialogAlignment.Center,
      customStyle: true,
      offset: this.dialogOffset,
    }) : null;

  private shutdownDialogController: SCBCustomDialogWrapper =
    new SCBCustomDialogWrapper(this.shutdownDialogExpandController, this.shutdownDialogFoldController);

  private rebootDialogExpandController: CustomDialogController = new CustomDialogController({
    builder: PowerOffConfirmBuilder({
      vm: this.rebootVm
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  });

  private rebootDialogFoldController: CustomDialogController | null =
    DeviceHelper.isSuperFoldMachine() ? new CustomDialogController({
      builder: PowerOffConfirmBuilder({
        vm: this.rebootVm
      }),
      autoCancel: false,
      alignment: DialogAlignment.Center,
      customStyle: true,
      offset: this.dialogOffset,
    }) : null;

  private rebootDialogController: SCBCustomDialogWrapper =
    new SCBCustomDialogWrapper(this.rebootDialogExpandController, this.rebootDialogFoldController);

  isSupportHibernate(): boolean {
    if (DeviceHelper.isHYM()) {
      return false;
    }
    return true;
  }
  /**
   * @description 弹窗确认回调
   */
  private onConfirm: () => void = () => {
    log.showInfo(`onConfirm this.powerType = ${this.powerType} ${this.shutdownFlage}`);
    if (this.powerType === PowerMenuType.POWER_OFF) {
      if (!this.shutdownFlage) {
        return;
      }
      this.shutdownFlage = false;
      // 关机查询设置导致不关机，逻辑注释，直接关机
      /*let hibernateVal: string = sSettingsUtil.getValue(HIBERNATE_KEY);
      if (!hibernateVal || hibernateVal === '') {
        log.showInfo('get hibernateVal from db fail.');
        hibernateVal = IS_HIBERNATE_OPEN;
      }
      let onHibernate: boolean = hibernateVal === IS_HIBERNATE_OPEN;
      if (!this.isSupportHibernate()) {
        onHibernate = false;
      }
      log.showInfo(`onConfirm onHibernate:${onHibernate},isSupportHibernate:${this.isSupportHibernate()}`);
      onHibernate ? mModel.hibernate() : mModel.shutdown();*/
      mModel.shutdown();
      this.dialogController.closeDialog();
      this.onCancel();
      return;
    }
    if (this.powerType != undefined) {
      PowerViewModel.handlePowerMenuClick(this.powerType);
    }
  }

  /**
   * @description 弹窗取消回调
   */
  private onCancel:() => void = () =>{
    log.showInfo(`onCancel this.powerType = ${this.powerType}`);
    this.onDialogCancel();
    this.dialogController.closeDialog();
  }

  /**
   * @description 菜单点击回调
   */
  private onMenuClick:() => void = async () =>{
    log.showInfo('onClicked');
    if (this.powerType === PowerMenuType.DORMANT) {
      PowerViewModel.handlePowerMenuClick(this.powerType);
    } else {
      this.openDialog();
    }
  }

  private updateVirtualMachineStatus(): void {
    const value: string = settingsDataManager.getValue(null, HWF_SHUTDOWN_ALLOWED, 'true');
    log.showInfo(`hwf.shutdown.allowed ${value}`);
    if (value === 'false') {
      this.isVirtualMachineUpdating = true;
    } else {
      this.isVirtualMachineUpdating = false;
    }
  }

  /**
   * @description 打开对话框
   */
  private async openDialog(): Promise<void> {
    log.showInfo(TAG, 'openDialog');
    // 虚拟机还在更新时，点击重启和关机需要显示虚拟机定制单框提示
    this.updateVirtualMachineStatus();
    log.showInfo(`isVirtualMachineUpdating  ${this.isVirtualMachineUpdating}`);
    if (this.isVirtualMachineUpdating) {
      this.dialogController.openDialog();
      this.onDialogShow();
      return;
    }
    try {
      const isExistOtherLoginUser = await mSystemPanelModel.isExistOtherLoginUser();
      if (isExistOtherLoginUser) {
        this.openMultiUserDialog(this.powerType);
      } else {
        this.dialogController.openDialog();
      }
      this.onDialogShow();
    } catch (err) {
      log.showError(TAG, `openDialog failed with error ${err?.code} ${err?.message}`);
    }
  }

  /**
   * @description 多用户弹框
   */
  private openMultiUserDialog(powerType:PowerMenuType | undefined): void {
    switch (powerType) {
      case PowerMenuType.POWER_OFF:
        log.showInfo(TAG, 'shutdownDialog open');
        this.shutDownVm.updateUserList();
        this.shutdownDialogController.openDialog();
        break;
      case PowerMenuType.RESTART:
        log.showInfo(TAG, 'rebootDialog open');
        this.rebootVm.updateUserList();
        this.rebootDialogController.openDialog();
        break;
      default:
        log.showWarn(TAG, 'null dialog open');
        break;
    }
  }

  /**
   * @description 构建弹窗对象
   */
  private dialogExpandController: CustomDialogController = new CustomDialogController({
    builder: PowerDialog({
      positiveButton: this.textContent,
      dialogMessage: this.dialogMsg,
      onConfirm: this.onConfirm,
      onCancel: this.onCancel,
      powerType: this.powerType,
      isVirtualMachineUpdating: this.isVirtualMachineUpdating
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  });

  /**
   * @description 构建悬浮态弹窗
   */
  private dialogFoldController: CustomDialogController | null =
    DeviceHelper.isSuperFoldMachine() ? new CustomDialogController({
      builder: PowerDialog({
        positiveButton: this.textContent,
        dialogMessage: this.dialogMsg,
        onConfirm: this.onConfirm,
        onCancel: this.onCancel,
        powerType: this.powerType,
        isVirtualMachineUpdating: this.isVirtualMachineUpdating
      }),
      autoCancel: false,
      alignment: DialogAlignment.Center,
      customStyle: true,
      offset: this.dialogOffset,
    }) : null;
  private dialogController: SCBCustomDialogWrapper =
    new SCBCustomDialogWrapper(this.dialogExpandController, this.dialogFoldController);

  /**
   *
   * @returns 菜单类型名称
   */
  private getMenuTypeName(): string {
    switch (this.powerType) {
      case PowerMenuType.DORMANT:
        return KEY + 'sleep';
      case PowerMenuType.RESTART:
        return KEY + 'reboot';
      case PowerMenuType.POWER_OFF:
        return KEY + 'shutdown';
      default:
        log.showError('getMenuTypeName, unknown action type.');
        return '';
    }
  }

  /**
   * @description 处理点击菜单事件
   * @param event 点击事件
   */
  private onClickEvent(event?: ClickEvent): void {
    log.showInfo(`onClickEvent, event: ${JSON.stringify(event)}`);
    if (this.mIsRunning || this.globalClickable) {
      return;
    }
    this.mIsRunning = true;
    this.globalClickable = true;
    this.onMenuClick();
    this.mTimeMeter = setTimeout(() => {
      log.showInfo('check need run task or not.');
      this.mIsRunning = false;
      this.globalClickable = false;
    }, this.mInterval);
  }

  /**
   * @description 睡眠菜单项请求聚焦
   * @param reason 请求焦点原因
   */
  private requestFocus(reason?: string): void {
    let isSuccess = focusControl.requestFocus(Constants.REQUEST_FOCUS_MENU);
    log.showInfo(`power menu requestFocus, reson:${reason} isSuccess = ${isSuccess}`);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    // The requestFocus has time sequence restrictions.
    // Ensure that the requested component is in the focus state when the requestFocus is invoked.
    this.mTimeMeterOfPowerMenu = setTimeout(() => {
      this.requestFocus('aboutToAppear');
    }, 20);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    clearTimeout(this.mTimeMeter);
    this.dialogController.destroy();
    this.shutdownDialogController.destroy();
    this.rebootDialogController.destroy();
  }

  /**
   * @description 多态样式 菜单背景颜色
   */
  @Styles normalStyles() {
    .border( {
      width: '2vp',
      color: '#00000000'
    })
    .backgroundColor(this.backgroundClr)
  }

  /**
   * @description 多态样式 菜单聚焦时边框颜色
   */
  @Styles focusedStyles() {
    .border( {
      width: '2vp',
      color: $r('sys.color.ohos_id_color_focused_outline')
    })
    .backgroundColor(this.backgroundClr)
  }

  /**
   * @description 多态样式 按压时菜单背景颜色
   */
  @Styles pressedStyles() {
    .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
  }

  build() {
    Row() {
      Text(this.textContent).draggable(false)
        .id(COMPONENT_ID_CONTENT)
        .font({
          family: 'HarmonyHeiTi',
          weight: FontWeight.Medium,
          size: $r('app.float.screenLock_powermenu_fontsize')
        })
        .fontColor(this.panelInfo?.listTextColor)
    }
    .key(this.getMenuTypeName())
    .height(Constants.POWER_MENU_ITEM_HEIGHT)
    .width(172)
    .justifyContent(FlexAlign.Start)
    .padding({
      left: 18
    })
    .borderRadius(Constants.POWER_HOVER_RADIUS)
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles,
      pressed: this.pressedStyles
    })
    .onHover((hover?: boolean) => {
      this.backgroundClr = hover ? $r('sys.color.ohos_id_color_hover') : this.styleClickable.stackBgColorUnSelected;
    })
    .onClick((event) => {
      this.onClickEvent(event);
    })
    .onTouch((event: TouchEvent) => {
      event.stopPropagation();
    })
  }
}
