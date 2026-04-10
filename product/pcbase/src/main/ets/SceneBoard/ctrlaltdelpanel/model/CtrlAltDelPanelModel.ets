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
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import { DeviceHelper, EventManager,
  EvtBus,
  HiSysEventUtil,
  viewMgrPolicy,
  ViewType,
} from '@ohos/frameworkwrapper';
import {
  sSampleManager,
  SCBSceneSessionManager,
  SCBOobeManager,
} from '@ohos/windowscene';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import screenLockService from '../../screenlock/refactor/ScreenLockService';
import { ScreenLockApi, screenLockStateManager } from '@ohos/screenlockcommon';
import Constants from '../common/Constants';
import osAccount from '@ohos.account.osAccount';
import { MultiInputViewModel } from '@ohos/multiinput/src/main/ets/default/common/viewmodel/MultiInputViewModel';
import { LogoutUserType, SwitchUserType, UserReportUtil } from '../../userspanel/common/UserReportUtil';
import { multiInputManager } from '@ohos/multiinput/src/main/ets/default/common/MultiInputManager';
import { ShortcutKeyConstants } from '../../../common/constants/ShortcutKeyConstants';
import { emitter } from '@kit.BasicServicesKit';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { FunctionListInfo } from '../common/FunctionListInfo';
import { SwitchAccountAnimationMethod } from '../../screenlock/pages/SwitchAccountAnimation';
import { inputConsumer, KeyCode } from '@kit.InputKit';

const TAG = 'CtrlAltDelPanelModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
const DEFAULT_FOCUS_INDEX: number = 0;

export class CtrlAltDelPanelModel {
  private nextFocus: number = 0;
  private isPCMode: boolean = DeviceHelper.is2In1DevicePcType();
  public functionList: FunctionListInfo[] = [];
  public functionListLength: number = 0;
  public focusMoveIndex = AppStorage.setAndLink('FocusMoveIndex', Constants.DEFAULT_FOCUS_INDEX);

  constructor() {
    this.getFunctionListMap();
    this.nextFocus = Constants.DEFAULT_FOCUS_INDEX;
    this.focusMoveIndex.set(DEFAULT_FOCUS_INDEX);
  }

  public ctlAltDelCallBack(): void {
    const isLocked: boolean = ScreenLockApi.getLock();
    const isOobeEnable: boolean = SCBOobeManager.isOobeActivated();
    log.showInfo(`ctlAltDelCallBack, isOobeEnable: ${isOobeEnable}, isLocked: ${isLocked}`);
    if (isLocked || isOobeEnable || SCBSceneSessionManager.getInstance().isScreenLocked() ||
      sSampleManager.isSampleManagerChecked()) {
      return;
    }
    if (!this.checkCtrlAltDelPanelShow()) {
      AppStorage.setOrCreate('showRecent', false);
      AppStorage.setOrCreate('isCtrlAltDelPanelShow', true);
      if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
        AppStorage.setOrCreate('isAppCenterShow', false);
      }
      HiSysEventUtil.reportKey(Constants.EVENT_CTRL_ALT_DEL);
    }
  }

  private getFunctionListMap(): void {
    const funListMap: FunctionListInfo[] = [
      {
        id: Constants.FUNCTION_ITEN_LOCK_SCREEN,
        name: $r('app.string.lock_screen'),
        imageRes: $r('app.media.lock_screen'),
        action: this.clickLockScreen
      },
      // {
      //   id: Constants.FUNCTION_ITEN_LOGOUT,
      //   name: $r('app.string.logout'),
      //   imageRes: $r('app.media.ctrlaltdel_arrow_right_and_square'),
      //   action: this.clickLogout,
      //   notInvolve: this.isPCMode
      // },
      // {
      //   id: Constants.FUNCTION_ITEN_SWITCH_USER,
      //   name: $r('app.string.switch_user'),
      //   imageRes: $r('app.media.ctrlaltdel_person_2_badge_arrow_2_circlepath'),
      //   action: this.clickSwitchUser,
      //   notInvolve: SwitchAccountAnimationMethod.enableEnterpriseSpace() || this.isPCMode,
      // },
      {
        id: Constants.FUNCTION_ITEN_TASK_MANAGER,
        name: $r('app.string.system_task_manager'),
        imageRes: $r('app.media.task_manager'),
        action: this.clickTaskManager
      },
      {
        id: Constants.FUNCTION_ITEN_FORCE_EXIT,
        name: $r('app.string.system_force_exit'),
        imageRes: $r('app.media.ctrlaltdel_xmark_circle'),
        action: this.clickForceExit
      },
      {
        id: Constants.FUNCTION_ITEN_CANEL,
        name: $r('app.string.cancel'),
        action: this.clickCancel
      }
    ];
    funListMap.forEach((item: FunctionListInfo) => {
      if (!item.notInvolve) {
        this.functionListLength = this.functionList.push(item);
      }
    })
  }

  public registerKeyInCtrlAltDelPanel(): void {
    const isLocked: boolean = ScreenLockApi.getLock();
    const isOobeEnable: boolean = SCBOobeManager.isOobeActivated();
    log.showInfo(`registerKeyInCtrlAltDelPanel, isOobeEnable: ${isOobeEnable}, isLocked: ${isLocked}`);
    if (isLocked || isOobeEnable || SCBSceneSessionManager.getInstance().isScreenLocked() ||
    sSampleManager.isSampleManagerChecked()) {
      return;
    }
    log.showInfo(`registerKeyInCtrlAltDelPanel`);
    multiInputManager.registerTempInput(ShortcutKeyConstants.LEFT_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.LEFT');
      ctrlAltDelPanelModel?.countFocusMoveIndexRight2Left();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.RIGHT_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.RIGHT');
      ctrlAltDelPanelModel?.countFocusMoveIndexLeft2Right();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.UP_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.UP');
      ctrlAltDelPanelModel?.countFocusMoveIndexRight2Left();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.DOWN_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.DOWN');
      ctrlAltDelPanelModel?.countFocusMoveIndexLeft2Right();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.TAB_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.TAB');
      ctrlAltDelPanelModel?.countFocusMoveIndexLeft2Right();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ENTER_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.ENTER');
      this.functionList[this.nextFocus].action();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.SPACE_OPTION, () => {
      HiSysEventUtil.reportKey('usual.event.SPACE');
      this.functionList[this.nextFocus].action();
    });
    multiInputManager.registerTempInput(ShortcutKeyConstants.ESC_UP_OPTION, this.clickCancel);
  }

  public unRegisterKeyInCtrlAltDelPanel(): void {
    this.focusMoveIndex.set(DEFAULT_FOCUS_INDEX);
    this.nextFocus = Constants.DEFAULT_FOCUS_INDEX;
    const isLocked: boolean = ScreenLockApi.getLock();
    const isOobeEnable: boolean = SCBOobeManager.isOobeActivated();
    log.showInfo(`registerKeyInCtrlAltDelPanel, isOobeEnable: ${isOobeEnable}, isLocked: ${isLocked}`);
    if (isLocked || isOobeEnable || SCBSceneSessionManager.getInstance().isScreenLocked() ||
    sSampleManager.isSampleManagerChecked()) {
      return;
    }
    log.showInfo(`unRegisterKeyInCtrlAltDelPanel`);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.LEFT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.RIGHT_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.UP_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.DOWN_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.TAB_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ENTER_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.SPACE_OPTION);
    multiInputManager.unRegisterTempInput(ShortcutKeyConstants.ESC_UP_OPTION);
  }

  public countFocusMoveIndexLeft2Right(): void {
    this.nextFocus = (this.nextFocus + 1) % this.functionList.length;
    this.focusMoveIndex.set(this.nextFocus);
    log.showInfo(`countFocusMoveIndex: ${this.nextFocus}, ${this.focusMoveIndex.get()}`);
  }

  public countFocusMoveIndexRight2Left(): void {
    this.nextFocus = (this.nextFocus - 1) % this.functionList.length < 0 ? (this.functionList.length - 1) :
      (this.nextFocus - 1) % this.functionList.length;
    this.focusMoveIndex.set(this.nextFocus);
    log.showInfo(`countFocusMoveIndexSubstruct: ${this.nextFocus}, ${this.focusMoveIndex.get()}`);
  }

  public checkCtrlAltDelPanelShow(): boolean {
    let isCtrlAltDelPanelShow: boolean = AppStorage.get<boolean>('isCtrlAltDelPanelShow') ?? false;
    log.showInfo(`checkCtrlAltDelPanelShow isCtrlAltDelPanelShow: ${isCtrlAltDelPanelShow}`);
    return isCtrlAltDelPanelShow;
  }

  public onLockScreen(): void {
    log.showInfo('onLockScreen');
    if (this.checkCtrlAltDelPanelShow()) {
      AppStorage.setOrCreate('isCtrlAltDelPanelShow', false);
    }
  }

  public clickForceExit: () => void = () => {
    log.showInfo('clickForceExit');
    let forceExtensionComponentStatus: boolean | undefined = AppStorage.get('isForceExtensionComponentShow');
    if (this.checkCtrlAltDelPanelShow()) {
      AppStorage.setOrCreate('isCtrlAltDelPanelShow', false);
      if (!forceExtensionComponentStatus) {
        AppStorage.setOrCreate('isForceExtensionComponentShow', true);
      }
    }
  }

  public clickLockScreen: () => void = () => {
    log.showInfo('clickLockScreen');
    AppStorage.setOrCreate('isCtrlAltDelPanelShow', false);
    if (this.isPCMode) {
      MultiInputViewModel.getInstance().winLCallBack();
      return;
    }
    try {
      screenLockMediator.doScreenLockWithLocalCallback(() => {
        log.showInfo(TAG, 'lockScreen success');
      });
    } catch (err) {
      log.showError(TAG, `lock fail, promise: err->${JSON.stringify(err)}`);
    }
  }

  public clickLogout: () => void = () => {
    log.showInfo('clickLogout');
    let isVirtualMachineUpdating: boolean = this.checkVmUpdate();
    if (isVirtualMachineUpdating) {
      log.showInfo(TAG, 'vm is updating, show dialog');
      emitter.emit(Constants.LOGOUT_FROM_SCREEN_LOCK);
      return;
    }
    UserReportUtil.reportLogoutUserEvent(LogoutUserType.CTRL_ALT_DEL_PANEL);
    AppStorage.setOrCreate('clickLogout', true);
  }

  public clickSwitchUser: () => void = () => {
    log.showInfo('clickSwitchUser');
    try {
      screenLockService.updateAllUsers();
      setTimeout(() => {
        log.showInfo('doScreenLock');
        let allUserNum: number | undefined = AppStorage.get('createdListLen');
        log.showInfo(`allUserLength:${allUserNum}`);
        if (!allUserNum || allUserNum <= 1) {
          log.showInfo(`can not switch user!`);
          UserReportUtil.reportSwitchUserEvent(undefined, SwitchUserType.CTRL_ALT_DEL_PANEL, 1);
        } else {
          AppStorage.setOrCreate('ctlaltdelSlectSwitchUser', true);
          UserReportUtil.reportSwitchUserEvent(undefined, SwitchUserType.CTRL_ALT_DEL_PANEL);
        }
        AppStorage.setOrCreate('isCtrlAltDelPanelShow', false);
        screenLockMediator.doScreenLockWithLocalCallback(() => {
          log.showInfo(TAG, 'lockScreen success');
        });
      }, 50);
    } catch (err) {
      log.showError(TAG, `lock fail, promise: err->${JSON.stringify(err)}`);
    }
  }

  public clickTaskManager: () => void = () => {
    log.showInfo('clickTaskManager');
    AppStorage.setOrCreate('isCtrlAltDelPanelShow', false);
    MultiInputViewModel.getInstance().winOpenTaskManagerCallBack();
  }

  public clickCancel: () => void = () => {
    log.showInfo('clickCancel');
    AppStorage.setOrCreate('isCtrlAltDelPanelShow', false);
  }

  public checkVmUpdate(): boolean {
    let virtualMachineVal: string = settingsDataManager.getValue(null, Constants.VIRTUAL_MACHINE_KEY, 'true');
    log.showInfo(`virtualMachineVal: ${virtualMachineVal}`);
    let isVirtualMachineUpdating: boolean = virtualMachineVal === 'false' ? true : false;
    return isVirtualMachineUpdating;
  }
}

let ctrlAltDelPanelModel = SingletonHelper.getInstance(CtrlAltDelPanelModel, TAG);

export default ctrlAltDelPanelModel as CtrlAltDelPanelModel;