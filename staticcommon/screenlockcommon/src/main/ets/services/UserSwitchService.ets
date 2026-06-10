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
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager, SCBSceneSessionManager, UserSwitchEventType } from '@ohos/windowscene';
import { AbstractObserverManager } from '../base/AbstractObserverManager';
import commonEventMonitor from '../base/CommonEventMonitor';
import { IUserData } from '../bean/IUserData';
import CommonConstants from '../constants/CommonConstants';
import { AccountHelper, SwitchEventData } from '../utils/AccountHelper';
import { PowerUtils } from '../utils/PowerUtils';
import { SlServerHelper } from '../utils/SlServerHelper';
import { ScreenOnOffService } from './ScreenOnOffService';

const TAG = 'UserSwitchService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
/**
 * 用户切换事件监听
 */
export interface UserSwitchListener {
  /**
   * 切换中事件通知
   *
   * @param switchEventData 切换事件数据
   */
  onSwitching?: (switchEventData: SwitchEventData) => void;

  /**
   * 切换完成事件通知
   *
   * @param switchEventData 切换事件数据
   */
  onSwitched?: (switchEventData: SwitchEventData) => void;

  /**
   * 用户激活状态变化通知
   *
   * @param isCurrentUserActive 当前用户是否激活
   */
  onUserActiveChanged?: (isCurrentUserActive: boolean) => void;
}

/**
 * 用户切换服务
 */
export class UserSwitchService extends AbstractObserverManager<UserSwitchListener> {
  private static sInstance: UserSwitchService;

  public static getInstance(): UserSwitchService {
    if (UserSwitchService.sInstance == null) {
      UserSwitchService.sInstance = new UserSwitchService();
    }
    return UserSwitchService.sInstance;
  }

  private _currentUserActive: boolean = true;

  private _isUserSwitching: boolean = false;

  private constructor() {
    super();
  }

  public get isCurrentUserActive(): boolean {
    return this._currentUserActive;
  }

  private set isCurrentUserActive(currentUserActive: boolean) {
    if (this._currentUserActive !== currentUserActive) {
      this._currentUserActive = currentUserActive;
      SlServerHelper.getInstance().setCurrentUserActive(currentUserActive);
      this.broadcastDataChange(observer => observer?.onUserActiveChanged?.(this._currentUserActive));
    }
  }

  public get isUserSwitching(): boolean {
    return this._isUserSwitching;
  }

  public set isUserSwitching(isUserSwitching: boolean) {
    if (this._isUserSwitching !== isUserSwitching) {
      this._isUserSwitching = isUserSwitching;
    }
  }

  protected doInit(): void {
    log.showInfo('doInit');
    AccountHelper.getInstance().registerUserSwitchListener('switching', this.handleSwitchingEvent.bind(this));
    AccountHelper.getInstance().registerUserSwitchListener('switched', this.handleSwitchedEvent.bind(this));

    commonEventMonitor.init();
    AccountHelper.getInstance().isForegroundUser((isForegroundUser: boolean): void => {
      if (isForegroundUser) {
        log.showInfo('is current user active.');
        this.isCurrentUserActive = true;
        SlServerHelper.getInstance().onSystemEvent();
      } else {
        log.showInfo('is current user not active.');
        this.isCurrentUserActive = false;
      }
    });
  }

  protected doRelease(): void {
    log.showInfo('doRelease');
    AccountHelper.getInstance().unRegisterUserSwitchListener('switching', this.handleSwitchingEvent.bind(this));
    AccountHelper.getInstance().unRegisterUserSwitchListener('switched', this.handleSwitchedEvent.bind(this));

    commonEventMonitor.destroy();
  }

  private handleSwitchingEvent(switchData: SwitchEventData): void {
    log.showWarn(`receive user switching, <${switchData?.fromAccountId} -> ${switchData?.toAccountId}>`);
    if (!switchData) {
      log.showWarn('handleSwitchingEvent invalid switchData.');
      return;
    }
    if (switchData.fromAccountId === switchData.toAccountId) {
      log.showInfo('handleSwitchingEvent user not change.');
      return;
    }
    this.isUserSwitching = true;

    SCBSceneSessionManager.getInstance().handleUserSwitchEvent(UserSwitchEventType.SWITCHING, switchData.toAccountId);

    let currentUser: IUserData | undefined = AppStorage.get<IUserData>(CommonConstants.CURRENT_USER_KEY);
    HiDfxEventUtil.reportUserSwitchEvent(currentUser?.type);

    if (AccountHelper.getInstance().currentLocalId === switchData.toAccountId) {
      log.showInfo('current user to active.');
      // 锁屏服务端只支持单个注册，因此需要重新激活
      this.isCurrentUserActive = true;
      SlServerHelper.getInstance().onSystemEvent();
    } else {
      // 如果是非当前用户将激活，则不处理
      log.showInfo(`not current user ${AccountHelper.getInstance().currentLocalId} to active.`);
      if (ScreenOnOffService.getInstance().isIntoSleep) {
        SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.MSG_NOTIFY_CANCEL_OFF_SCREEN);
        PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
      }
      if (!PowerUtils.isActive()) {
        PowerUtils.asyncWakeupDevice(PowerUtils.WAKEUP_DETAIL_FINGER_AUTH_SUCCESS);
      }

      this.isCurrentUserActive = false;
    }

    this.broadcastDataChange(observer => observer.onSwitching?.(switchData));
  }

  private handleSwitchedEvent(switchData: SwitchEventData): void {
    log.showWarn(`receive user switched, <${switchData?.fromAccountId} -> ${switchData?.toAccountId}>`);
    if (!switchData) {
      log.showWarn('handleSwitchedEvent invalid switchData.');
      return;
    }
    if (switchData.fromAccountId === switchData.toAccountId) {
      log.showInfo('handleSwitchedEvent user not change.');
      return;
    }
    this.isUserSwitching = false;
    // notify wms to handle user switched event
    SCBSceneSessionManager.getInstance().handleUserSwitchEvent(UserSwitchEventType.SWITCHED, switchData.toAccountId);

    this.broadcastDataChange(observer => observer.onSwitched?.(switchData));
  }
}