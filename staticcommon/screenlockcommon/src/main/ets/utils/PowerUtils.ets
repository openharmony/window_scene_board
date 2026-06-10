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

import power from '@ohos.power';
import taskPool from '@ohos.taskpool';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SCBScreenSessionManager } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSessionManager';
import { UserSwitchService } from '../services/UserSwitchService';

const TAG = 'PowerUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SCREEN_LOCK_SCREEN_OFF_TIME: number = 10000;
const RESTORE_DEFAULT_TIME: number = -1;

export class PowerUtils {
  /**
   * 亮屏原因：预亮屏（上电不亮屏）
   */
  public static readonly WAKEUP_DETAIL_PRE_BRIGHT: string = 'pre_bright';

  /**
   * 亮屏原因：预亮屏，认证成功（亮屏）
   */
  public static readonly WAKEUP_DETAIL_PRE_BRIGHT_SUCCESS: string = 'pre_bright_auth_success';

  /**
   * 亮屏原因：预亮屏，认证失败，需要亮屏（亮屏）
   */
  public static readonly WAKEUP_DETAIL_PRE_BRIGHT_FAIL_ON: string = 'pre_bright_auth_fail_screen_on';

  /**
   * 亮屏原因：预亮屏，认证失败，需要灭屏（下电）
   */
  public static readonly WAKEUP_DETAIL_PRE_BRIGHT_FAIL_OFF: string = 'pre_bright_auth_fail_screen_off';

  /**
   * 亮屏原因：指纹解锁成功
   */
  public static readonly WAKEUP_DETAIL_FINGER_AUTH_SUCCESS: string = 'screen_lock_auth_ok';

  /**
   * 亮屏原因：人脸认证成功
   */
  public static readonly WAKEUP_DETAIL_FACE_AUTH_SUCCESS: string = 'ScreenLock_face_verify_success';

  /**
   * 亮屏原因：假AOD状态上滑解锁
   */
  public static readonly WAKEUP_DETAIL_AOD_SLIDE_UNLOCK: string = 'fake_aod_slide_unlock';

  /**
   * 亮屏原因：假AOD状态双击亮屏
   */
  public static readonly WAKEUP_DETAIL_AOD_DOUBLE_TAP_UNLOCK: string = 'fake_aod_double_tap_unlock';

  /**
   * 亮屏原因：外屏灭屏过程中解锁
   */
  public static readonly WAKEUP_DETAIL_OUTER_HOME_AOD_UNLOCK: string = 'outer_home_fake_aod_unlock';

  /**
   * 通知电源做LCD亮屏
   */
  public static readonly NOTIFY_OFF_SCREEN_OPEN_LCD: number = 2;

  /**
   * 通知电源做LCD灭屏
   */
  public static readonly NOTIFY_OFF_SCREEN_CLOSE_LCD: number = 3;

  /**
   * 假AOD解锁场景，拦截RS灭屏消息
   */
  public static readonly MSG_NOTIFY_CANCEL_OFF_SCREEN: number = 4;

  /**
   * 串行任务队列（高优先级）
   */
  private static sequenceRunner: taskPool.SequenceRunner = new taskPool.SequenceRunner(taskPool.Priority.HIGH);

  /**
   * 异步唤醒设备
   *
   * @param detail 唤醒原因
   */
  public static async asyncWakeupDevice(detail: string): Promise<void> {
    try {
      log.showWarn(`asyncWakeupDevice ${detail} begin`);
      let task = new taskPool.Task(wakeupDevice, detail);
      await PowerUtils.sequenceRunner.execute(task).then((result: Object) => {
        log.showWarn(`asyncWakeupDevice ${detail} result: ${result as boolean}`);
      });
    } catch (error) {
      log.showError(`asyncWakeupDevice ${detail} error`);
    }
  }

  /**
   * 假AOD阻止屏幕下电并重新唤醒设备
   *
   * @param detail 唤醒原因
   */
  public static async wakeupDeviceInFakeAod(detail: string): Promise<void> {
    PowerUtils.asyncWakeupDevice(detail);
    if (PowerUtils.isActive()) {
      SCBScreenSessionManager.getInstance().notifyScreenLockEvent(PowerUtils.MSG_NOTIFY_CANCEL_OFF_SCREEN);
    }
  }

  /**
   * 判断是否活跃状态
   *
   * @returns 是否活跃状态
   */
  public static isActive(): boolean {
    try {
      return power.isActive();
    } catch (error) {
      log.showError(`isActive failed. ${error.code}`);
    }
    return false;
  }

  /**
   * 设置熄屏时间
   */
  public static setScreenOffTime(isSlOffTime: boolean): void {
    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      log.showInfo(`setScreenOffTime, user not active`);
      return;
    }
    log.showInfo(`setScreenOffTime, isSlOffTime: ${isSlOffTime}`);
    try {
      power.setScreenOffTime(isSlOffTime ? SCREEN_LOCK_SCREEN_OFF_TIME : RESTORE_DEFAULT_TIME);
    } catch (error) {
      log.showError(`setScreenOffTime failed, err: ${error.code}`);
    }
  }

  /**
   * 关闭屏幕
   * @param isImmediate 是否立即暂停设备运行。
   */
  public static suspend(isImmediate?: boolean): void {
    log.showInfo(`suspend, isImmediate: ${isImmediate}`);
    try {
      power.suspend(isImmediate);
    } catch (error) {
      log.showError(`suspend failed, err: ${error.code}`);
    }
  }

  /**
   * 刷新亮屏时间
   *
   * @param reason
   */
  public static refreshActivity(reason: string): void {
    log.showDebug(`refreshActivity, reason: ${reason}`);
    try {
      power.refreshActivity(reason);
    } catch (error) {
      log.showError(`refreshActivity failed, refresh reason: ${reason}, err: ${error.code}`);
    }
  }
}

function wakeupDevice(detail: string): boolean {
  'use concurrent';
  const TAG = 'PowerUtils';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
  try {
    log.showInfo('wakeupDevice begin');
    power.wakeup(detail);
    log.showInfo('wakeupDevice end');
    return true;
  } catch (err) {
    log.showError('wakeup failed, err');
    return false;
  }
}