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
import { BaseViewController } from '@ohos/frameworkcommon';
import { ViewCallback, viewMgrPolicy, ViewType, settingsDataManager } from '@ohos/frameworkwrapper';
import { StyleConstants } from '@ohos/launchercommon';
import { CommonData } from '@ohos/controlcentercommon/Index';
import { SCBSceneSessionManager, SCBScreenProperty, SCBScreenSessionManager,
  SCBSystemSceneSession } from '@ohos/windowscene';
import { Constants } from '../../common/Constants';
import DialogFoldModel, { DialogChangeCallback } from '../../common/DialogFoldModel';
import { ConfirmVMFactory } from './LogoutConfirm/DialogConfigFactory';
import { ConfirmBuilder, LogoutConfirmVM } from './LogoutConfirm/LogoutConfirm';
import mSystemPanelModel from '../../../systempanel/model/SystemPanelModel';
import { emitter } from '@kit.BasicServicesKit';

const TAG = 'SCBDialogView';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Component
export struct SCBDialogView {
  persistentId: number = 0;
  @Link screenProp: SCBScreenProperty;
  systemSceneSession?: SCBSystemSceneSession;
  @State dialogViewController: BaseViewController = new BaseViewController(ViewType.DIALOG_VIEW);
  @State dialogOffsetY: number = 0;
  @State dlgHeight: number = Constants.DIALOG_MAX_HEIGHT;
  @StorageLink('DarkModeModel_DarkModeStatus') @Watch('onDarkModeChanged') darkModeData: CommonData = new CommonData();
  @StorageLink('currentClickItem') dialogName: string = '';
  @State @Watch('userListNumberChange') vm: LogoutConfirmVM = ConfirmVMFactory.getInstance().getConfirmVMByName(this.dialogName);

  dialogController: CustomDialogController = new CustomDialogController({
    builder: ConfirmBuilder({vm: this.vm, dlgHeight: this.dlgHeight}),
    customStyle: true,
    maskColor: $r('app.color.transparent'),
    autoCancel: false
  });

  dialogViewCallback: ViewCallback = {
    onShow: () => {
      log.showInfo(`SCBDialogView onShow, dialogName: ${this.dialogName}`);
      this.vm = ConfirmVMFactory.getInstance().getConfirmVMByName(this.dialogName);
      this.vm.updateUserList();
      // 折叠场景
      DialogFoldModel.getInstance()
        .registerDialogChangeCallback(this.dialogChangeCallback);
      this.updateSize();
      this.dialogController.open();
      this.updateVmUpdateDialogStatus('true');
    },
    onHide: () => {
      log.showInfo(`SCBDialogView onHide, dialogName: ${this.dialogName}`);
      this.dialogController.close();
      DialogFoldModel.getInstance()
        .unregisterDialogChangeCallback(this.dialogChangeCallback);
      this.updateVmUpdateDialogStatus('false');
    }
  }

  private dialogChangeCallback: DialogChangeCallback = {
    onCustomDialogOffsetYChange: (offsetY: number) => {
      log.showInfo(`onCustomDialogOffsetYChange ${offsetY}`);
      this.dialogOffsetY = offsetY;
      this.updateDialogSize();
    },
  }

  // 多用户场景下获取当前登录用户需要一定时间，监听用户数量更新时更新显示内容
  userListNumberChange() {
    log.showInfo(`userListNumber: ${this.vm.userList.length}, dlgHeight: ${this.dlgHeight}`);
    // 重新更新窗口高度，防止切换弹框内容时，高度不变
    this.dlgHeight = Constants.DIALOG_MAX_HEIGHT;
    this.updateSize();
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    viewMgrPolicy.registerViewController(ViewType.DIALOG_VIEW, this.dialogViewController);
    viewMgrPolicy.registerViewCallback(ViewType.DIALOG_VIEW, this.dialogViewCallback);
    this.dialogViewController.updateId(this.persistentId);
    // 防止旋转场景跳闪
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);

    this.systemSceneSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId);
    this.systemSceneSession.radius = Constants.SHADOW_RADIUS;
    this.systemSceneSession.offsetX = Constants.SHADOW_OFFSET_X;
    this.systemSceneSession.offsetY = Constants.SHADOW_OFFSET_Y;
    this.systemSceneSession.borderRadius = Constants.DIALOG_BOARDER_RADIUS;
    this.onDarkModeChanged();
    this.registerLogoutListener();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    viewMgrPolicy.unregisterViewController(ViewType.DIALOG_VIEW);
    viewMgrPolicy.unRegisterViewCallback(ViewType.DIALOG_VIEW, this.dialogViewCallback);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallbacks);
    this.unRegisterLogoutListener();
  }


  build() {
    Column()
      .width(StyleConstants.PERCENTAGE_100)
      .height(this.dlgHeight)
      .onAreaChange((oldValue: Area, newValue: Area) => {
          if (oldValue.height !== newValue.height) {
            log.showInfo(`dlgHeight: ${this.dlgHeight}`);
            this.updateSize()
          }
      })
  }

  private onDarkModeChanged() {
    log.showInfo(`ondarkmodechanged data: ${this.darkModeData.status}`);
    if (this.systemSceneSession instanceof SCBSystemSceneSession) {
      this.systemSceneSession.color = this.darkModeData.status ? Constants.SESSION_COLOR_DARK :
      Constants.SESSION_COLOR;
    }
  }

  private updateDialogOffsetY(): void {
    this.dialogOffsetY = 0;
  }

  private updateDialogSize() {
    this.dialogViewController.updateRect({
      left: (px2vp(this.screenProp.width) - Constants.DIALOG_WIDTH) / Constants.ONE_HALF_OF_SCREEN,
      top: (px2vp(this.screenProp.height) - this.dlgHeight) / Constants.ONE_HALF_OF_SCREEN + this.dialogOffsetY,
      width: Constants.DIALOG_WIDTH,
      height: this.dlgHeight
    })
    this.dialogViewController.updateArea({
      left: (px2vp(this.screenProp.width) - Constants.DIALOG_WIDTH) / Constants.ONE_HALF_OF_SCREEN,
      top: (px2vp(this.screenProp.height) - this.dlgHeight) / Constants.ONE_HALF_OF_SCREEN + this.dialogOffsetY,
      width: Constants.DIALOG_WIDTH,
      height: this.dlgHeight
    })
  }

  private updateSize() {
    this.updateDialogOffsetY();
    this.updateDialogSize();
  }

  private screenPropertyChangeCallbacks = () => {
    log.showInfo('screenPropertyChangeCallbacks');
    this.updateSize();
  }

  private openVmUpdateDialog = () => {
    log.showInfo(TAG, 'receive logout event from screen lock');
    mSystemPanelModel.setCurrentClickItem(Constants.LOGOUT);
    log.showInfo(TAG, 'show dialogName: logout');
    viewMgrPolicy.showView(ViewType.DIALOG_VIEW);
  }

  private registerLogoutListener() {
    emitter.on(Constants.LOGOUT_FROM_SCREEN_LOCK, this.openVmUpdateDialog)
  }

  private unRegisterLogoutListener() {
    emitter.off(Constants.LOGOUT_FROM_SCREEN_LOCK, this.openVmUpdateDialog);
  }

  private updateVmUpdateDialogStatus(flag: string): void {
    let isVirtualMachineUpdating: boolean = this.checkVmUpdate();
    if (isVirtualMachineUpdating) {
      log.showInfo(TAG, `vm update dialog status: ${flag}`);
      settingsDataManager.setValue(null, Constants.VIRTUAL_MACHINE_DIALOG_SHOW, flag);
    }
  }

  private checkVmUpdate(): boolean {
    let virtualMachineVal: string = settingsDataManager.getValue(null, Constants.VIRTUAL_MACHINE_KEY, 'true');
    log.showInfo(TAG, `virtualMachineVal: ${virtualMachineVal}`);
    let isVirtualMachineUpdating: boolean = virtualMachineVal === 'false' ? true : false;
    return isVirtualMachineUpdating;
  }
}