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
import { SCBSceneContainerSession, ResUtils } from '@ohos/windowscene';
import { AccessibilityManager, ResourceManager } from '@ohos/frameworkwrapper';
import { RecentEventViewModel } from '../../viewmodel/RecentEventViewModel';
import { RecentTitleViewModel } from '../../viewmodel/RecentTitleViewModel';

const TAG: string = 'RecentAccessibilityUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export enum LockType {
  LOCK = 0,
  UNLOCK = 1
}

export class RecentAccessibilityUtils {

  /**
   * 在无障碍模式进入多任务主动播报
   */
  public static textAnnouncedForFocusRecent(): void {
    let accessibilityManager = AccessibilityManager.getInstance();
    let isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      let recentText: string = ResUtils.getInnerString($r('app.string.running_apps_recently'));
      accessibilityManager.sendTextAnnouncedForAccessibility(recentText, 'textAnnouncedForFocusRecent');
    }
  }

  /**
   * 锁定/解锁卡片语音播报
   * @param appName 应用名称
   * @param sceneContainerSession
   */
  public static textAnnouncedForLockApp(appName: string, lockType: number): void {
    let accessibilityManager = AccessibilityManager.getInstance();
    let isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      RecentAccessibilityUtils.sendTextAnnounced(lockType, appName);
      log.showInfo(`textAnnouncedForLockApp ${lockType} appName: ${appName}`);
    }
  }

  private static sendTextAnnounced(lockType: number, name: string): void {
    let accessibilityManager = AccessibilityManager.getInstance();
    if (lockType === LockType.LOCK) {
      accessibilityManager.sendTextAnnouncedForAccessibility(
        ResUtils.getInnerStringNumS($r('app.string.lock_app'), name), 'textAnnouncedForLockApp')
    } else {
      accessibilityManager.sendTextAnnouncedForAccessibility(
        ResUtils.getInnerStringNumS($r('app.string.unlock_app'), name), 'textAnnouncedForLockApp')
    }
  }

  /**
   * 上滑删除单个任务主动播报
   */
  public static async textAnnouncedForClearApp(sceneContainerSession: SCBSceneContainerSession): Promise<void> {
    if (!sceneContainerSession) {
      return;
    }
    let accessibilityManager = AccessibilityManager.getInstance();
    let isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      let recentText: string = await ResourceManager.getInstance()
        .getStringByIdSync($r('app.string.cc_accessibility_str_open_action').id);
      let appName = await RecentAccessibilityUtils.getAccessibilityText(sceneContainerSession);
      recentText += appName;
      accessibilityManager.sendTextAnnouncedForAccessibility(recentText, 'textAnnouncedForClearApp');
      log.showInfo(`textAnnouncedForClearApp ${recentText}`);
    }
  }

  /**
   * 点击任务窗口获取播报primaryName
   */
  public static async textAnnouncedForClickTask(sceneContainerSession: SCBSceneContainerSession,
                                                nameCallback: (name: string) => void): Promise<void> {
    if (!sceneContainerSession) {
      return;
    }
    let accessibilityManager = AccessibilityManager.getInstance();
    let isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      let appName = await RecentAccessibilityUtils.getAccessibilityText(sceneContainerSession);
      nameCallback(appName);
    }
  }

  private static async getAccessibilityText(sceneContainerSession: SCBSceneContainerSession): Promise<string> {
    let appName: string = '';
    if (!sceneContainerSession) {
      return appName;
    }
    await RecentTitleViewModel.updateFirstSessionName(sceneContainerSession,
      (name: string): void => {
        appName = name;
      });
    await RecentTitleViewModel.updateSecondSessionName(sceneContainerSession,
      (name: string): void => {
        appName += ' ' + name;
      });
    return appName;
  }

  /**
   * 控件id主动获焦
   *
   * @param customId 组件id
   * @param tag 操作标识
   * @param isInterrupt 是否打断上次播报
   */
  public static requestFocusForAccessibility(customId: string, tag: string, isInterrupt: boolean = true): void {
    let accessibilityManager = AccessibilityManager.getInstance();
    let isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      log.showInfo(`requestFocusForAccessibility ${customId},${tag}`);
      accessibilityManager.requestFocusAccessibility(customId, isInterrupt);
    }
  }

  /**
   * 主动聚焦到对应的session
   *
   * @param session 需要聚焦的session
   * @param isInterrupt 是否打断上次播报
   */
  public static requestFocusForSession(session: SCBSceneContainerSession | undefined,
    isInterrupt: boolean = true): void {
    if (!session) {
      return;
    }
    let accessibilityManager = AccessibilityManager.getInstance();
    let isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      RecentAccessibilityUtils.requestFocusForAccessibility(RecentEventViewModel.getComponentId(session.containerId),
        TAG, isInterrupt);
    }
  }
}
