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
import { NotificationEntry } from '../model/NotificationEntry';
import { ntfMgr } from '../model/NotificationManager';
import { LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { ScreenLockApi } from '@ohos/screenlockcommon/src/main/ets/api/ScreenLockApi';
import { NotificationAction } from '@ohos/systemuicommon';
import { LiveUseScene, CardBorderRadius } from '@ohos/systemuicommon';
import { CloseAppManager } from '@ohos/launchercommon/src/main/ets/manager/CloseAppManager';
import { liveStartAnimMgr } from '@ohos/systemuicommon/Index';
import { NotificationConstants } from '../common/NotificationConstants';
import WantAgent, { WantAgent as _WantAgent } from '@ohos.app.ability.wantAgent';
import { NotificationConfig } from '../common/NotificationConfig';
import { NtfActionVM } from './NtfActionVM';

const TAG = 'KeyguardNtfActionVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const UNLOCK_DELAY = 300;

export class KeyguardNtfActionVM extends NtfActionVM {

  /**
   * start notification action
   *
   * @param action action
   * @param isAutoCancel ntfs's autoCancel
   * @param isAbility isUI jump
   * @param inputContent input content
   */
  startActionInner(action: NotificationAction, isAutoCancel: boolean, isAbility: boolean, inputContent?: string): void {
    let isKeyguardLock = this.getKeyguardLock();
    log.showInfo(`startActionInner isKeyguardLock:${isKeyguardLock}`);
    let entry: NotificationEntry | undefined = this.callback?.getNtfEntry();
    if (isAbility) {
      if (isKeyguardLock) {
        ScreenLockApi.requestUnlock({
          success: (): void => {
            this.startActionWantAgent(action,
              isAutoCancel,
              isAbility,
              entry as NotificationEntry,
              inputContent);
          }
        });
      } else {
        this.startLockNtfWantAgent(action, isAutoCancel, isAbility, entry as NotificationEntry, inputContent);
      }
    } else {
      this.startActionWantAgent(action, isAutoCancel, isAbility, entry as NotificationEntry, inputContent);
    }
  }

  /**
   * start screen lock notification  action
   *
   * @param action action
   * @param isAutoCancel ntfs's autoCancel
   * @param isStartAbility isUI jump
   * @param entry notification entry
   * @param inputContent input text
   */
  startLockNtfWantAgent(action: NotificationAction, isAutoCancel: boolean, isStartAbility: boolean,
    entry: NotificationEntry, inputContent?: string): void {
      ScreenLockApi.notifyEarlyUnlockTransition();
      this.startLockNtfDoWantAgent(entry, action, inputContent);
      setTimeout(() => {
        ScreenLockApi.requestUnlock();
      }, UNLOCK_DELAY);
  }

  private startLockNtfDoWantAgent =
    async (entry: NotificationEntry, action: NotificationAction, inputContent?: string,
      callback?: Callback<number>): Promise<void> => {
      log.showInfo(`start do want agent, hashcode: ${entry?.hashCode}`);
      let startAgent = (hasAnim: boolean = true) => {
        log.showInfo('enter startAgent');
        CloseAppManager.getInstance().setStartAppType(StartType.APP);
        ntfMgr.startWantAgent(action.wantAgent, callback, action.userInputKey, inputContent);
      };
      let bundleName = await this.getBundlerName(action.wantAgent);
      this.doStartAgent(entry, bundleName, startAgent);
    }

  /**
   * get bundler name
   *
   * @param wantAgent wantAgent
   * @returns bundler name
   */
  private async getBundlerName(wantAgent: _WantAgent): Promise<string> {
    let result = ''
    try {
      result = await WantAgent.getBundleName(wantAgent);
    } catch (err) {
      log.showError(`getBundlerName, code: ${err.code}`);
    }
    return result;
  }

  private doStartAgent = (entry: NotificationEntry, targetBundleName: string,
    startAgent: (hasAnim?: boolean) => void) => {
    liveStartAnimMgr.startAnimPre({
      cardId: entry.hashCode,
      startBundleName: targetBundleName,
      cardComponentId: this.getComponentId(entry),
      cardRadius: entry.groupEntry?.isGroup ? this.getGroupItemRadius() : undefined,
      scene: LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION,
      onPreComplete: startAgent,
      onAnimComplete: () => {
        if (entry.isAutoDelete) {
          ntfMgr.removeNotificationByClick(entry);
        }
      }
    });
  }

  /**
   * get component Id
   *
   * @param entry notification entry
   * @returns component id
   */
  getComponentId(entry: NotificationEntry): string | undefined {
    if (entry.isLiveType()) {
      return undefined;
    }
    return NotificationConstants.isGroupNTF(entry) ?
      NotificationConstants.getGroupNTFItemCompId(entry.getGroupKey()) :
      NotificationConstants.getNTFSingleItemCompId(LiveUseScene.SCENE_NTF_CENTER, entry.hashCode);
  }

  /**
   * get item radius
   *
   * @returns card border radius
   */
  private getGroupItemRadius(): CardBorderRadius | undefined {
    return {
      topLeft: NotificationConfig.BORDER_RADIUS,
      topRight: NotificationConfig.BORDER_RADIUS,
      bottomLeft: NotificationConfig.BORDER_RADIUS,
      bottomRight: NotificationConfig.BORDER_RADIUS
    };
  }
}