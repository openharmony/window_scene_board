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
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { AbstractLayoutChangeChecker } from './AbstractLayoutChangeChecker';
import { DesktopDataInfo } from './DesktopDataInfo';
import { AbilityFormUtil } from '../../utils/AbilityFormUtil';

const TAG = 'MainScreenLayoutChangeChecker';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议内屏桌面布局变化监听器
 *
 * @since 2025-02-18
 */
export class MainScreenLayoutChangeChecker extends AbstractLayoutChangeChecker {
  /**
   * 布局是否发生变化
   *
   * @returns 发生变化返回true
   */
  public isLayoutChange(screenIndex: number): boolean {
    const allForms: GridLayoutItemInfo[] = AbilityFormUtil.getVisibleVoiceList();
    // 布局变化的所在页是否有语音助手建议卡片

    const allFormStacks: GridLayoutItemInfo[] = AbilityFormUtil.getAllFormStackList();
    for (let i = 0; i < allForms.length; i++) {
      if (allForms[i] && allForms[i].page === screenIndex) {
        return true;
      }
    }

    // 布局变化的所在页的堆叠是否有语音助手建议卡片
    for (let i = 0; i < allFormStacks.length; i++) {
      const formStack = allFormStacks[i];
      if (formStack && AbilityFormUtil.isFormStackContainVoiceCard(formStack) && formStack.page === screenIndex) {
        return true;
      }
    }

    return false;
  }

  protected getDesktopDataInfo(): DesktopDataInfo | undefined {
    return AppStorage.get('appListInfo');
  }
}