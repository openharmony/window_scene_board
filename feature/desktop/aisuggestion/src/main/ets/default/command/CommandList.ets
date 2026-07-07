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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { CommonConstants } from '@ohos/launchercommon';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';

import type { BaseCommand } from './BaseCommand';
import { CommandValidator } from './CommandValidator';

const TAG = 'CommandList';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 同时最多执行3个命令
 */
const MAXIMUM_VALUE_FOR_SIMULTANEOUS_EXECUTION: number = 3;

/**
 * 命令队列
 *
 * @since 2024-07-14
 */
export class CommandList {
  private executeCommandList: BaseCommand[] = [];

  private pendingCommandMap: Map<string, BaseCommand[]> = new Map();

  private restCommandMap: Map<string, BaseCommand[]> = new Map();

  /**
   * Map<操作类型，Map<命令ID, 命令组>>
   */
  private cacheCommandMap: Map<number, Map<string, BaseCommand[]>> = new Map();

  public cacheCommands(cacheCommands: Map<number, Map<string, BaseCommand[]>>): void {
    this.cacheCommandMap = cacheCommands;
  }

  public getCacheCommands(): BaseCommand[] {
    return this.flatCommandMap(this.cacheCommandMap);
  }

  public getCacheCommandMap(): Map<number, Map<string, BaseCommand[]>> {
    return this.cacheCommandMap;
  }

  private flatCommandMap(map: Map<Number, Map<string, BaseCommand[]>>): BaseCommand[] {
    if (map == null) {
      return [];
    }
    return Array.from(map.values())
      .map(commandMap2 => Array.from(commandMap2.values())).flat(2);
  }

  public setRestCommands(): void {
    if (!this.cacheCommandMap || this.cacheCommandMap.size === 0) {
      log.showInfo('no more command to execute');
      return;
    }
    this.restCommandMap.clear();
    CommandValidator.filterInvalidCommand(this.cacheCommandMap);
    this.flatCommandMap(this.cacheCommandMap).forEach(command => {
      let restCommandList = this.restCommandMap.get(command.commandId) ?? [];
      restCommandList.push(command);
      this.restCommandMap.set(command.commandId, restCommandList);
    });
    this.cacheCommandMap.clear();
  }

  public setPendingCommands(): void {
    const commandIdSet: Set<string> = new Set(this.getPendingCommandIds());
    if (commandIdSet.size === 0) {
      return;
    }
    let isKeyGuard: boolean = ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD);
    const isExecuteAllCommands = !isKeyGuard;
    log.showInfo(`execute all commands: ${isExecuteAllCommands}`);
    for (const commandId of commandIdSet) {
      const commands = this.restCommandMap.get(commandId);
      if (CheckEmptyUtils.isEmptyArr(commands)) {
        continue;
      }
      if (!commands) {
        continue;
      }
      const pendingCommandList: BaseCommand[] = [];
      const restCommandList: BaseCommand[] = [];
      for (const command of commands) {
        if (this.canCommandExecute(isExecuteAllCommands, command)) {
          pendingCommandList.push(command);
          continue;
        }
        restCommandList.push(command);
      }
      if (!CheckEmptyUtils.isEmptyArr(pendingCommandList)) {
        this.pendingCommandMap.set(commandId, pendingCommandList);
      }
      this.restCommandMap.set(commandId, restCommandList);
      if (this.pendingCommandMap.size === MAXIMUM_VALUE_FOR_SIMULTANEOUS_EXECUTION) {
        // 只取前3个执行，执行完成后再取剩下的命令执行
        break;
      }
    }
  }

  public getPendingCommands(): string[] {
    return Array.from(this.pendingCommandMap.keys());
  }

  private canCommandExecute(isExecuteAllCommands: boolean, command: BaseCommand): boolean {
    if (!isExecuteAllCommands) {
      return command.commandType === AiSuggestionUpdateConstants.CommandType.UPDATE_CARD || command.commandType ===
        AiSuggestionUpdateConstants.CommandType.DELETE_CARD_FROM_STACK;
    }
    return true;
  }

  public needExecutePendingCommands(): boolean {
    const pendingCommands = Array.from(this.pendingCommandMap.values()).flat().filter(command => !command.isExpired());
    if (pendingCommands.length > 0) {
      return true;
    }
    return false;
  }

  public isCommandExecuting(): boolean {
    const pendingCommands = Array.from(this.pendingCommandMap.values()).flat().filter(command => !command.isExpired());
    const executeCommands = this.executeCommandList.filter(command => !command.isExpired());
    if (pendingCommands.length > 0 || executeCommands.length > 0) {
      return true;
    }
    return false;
  }

  public logExecutingCommands(): void {
    const pendingCommands =
      Array.from(this.pendingCommandMap.values()).flat().map(command => command.toStringWithExecuteTime());
    log.showInfo(`pendingCommands: ${pendingCommands.join(',')}`);

    const executeCommands = this.executeCommandList.map(command => command.toStringWithExecuteTime());
    log.showInfo(`executeCommands: ${executeCommands.join(',')}`);
  }

  public logPendingCommands(): void {
    const pendingCommands =
      Array.from(this.pendingCommandMap.values()).flat().map(command => command.toString());
    log.showInfo(`pendingCommands: ${pendingCommands.join(',')}`);
  }

  private getPendingCommandIds(): string[] {
    // 当前屏
    let pageIndex: number = desktopUtil.getPageIndexValue();
    log.showInfo(`getTargets currentPageIndex = ${pageIndex}`);

    // 优先级：当前屏 -> 左屏 -> 右屏
    const pages: number[] = [pageIndex, pageIndex - 1, pageIndex + 1];

    let pendingCommandIds: Set<string> = new Set();
    for (const page of pages) {
      // 找到当前屏和左右两屏的命令
      AbilityFormUtil.getTargets(page).filter(targetId => this.restCommandMap.has(targetId)).forEach(targetId => {
        pendingCommandIds.add(targetId);
      });
    }
    // 添加其他屏的刷新命令
    Array.from(this.restCommandMap.keys()).filter(commandId => !pendingCommandIds.has(commandId)).forEach(commandId => {
      pendingCommandIds.add(commandId);
    });
    return Array.from(pendingCommandIds);
  }

  public moveToNext(commandId: string | undefined): BaseCommand | undefined {
    if (!commandId) {
      return undefined;
    }
    let pendingCommandList: BaseCommand[] = this.pendingCommandMap.get(commandId) ?? [];
    if (!pendingCommandList || pendingCommandList.length <= 0) {
      return undefined;
    }
    const command = pendingCommandList.shift();
    log.showInfo(`move command to execute list, ${command?.toString()}`);
    if (pendingCommandList.length <= 0) {
      log.showInfo(`move command to execute list, no pending command left, delete key ${commandId}`);
      this.pendingCommandMap.delete(commandId);
    }
    if (command) {
      this.executeCommandList.push(command);
    }
    return command;
  }

  public removeExecutedCommand(commandId: string, commandType: number, operateCardId: string = ''): boolean {
    let executeCommandIndex: number = this.executeCommandList.findIndex((cmd) => {
      return this.isSameCommand(cmd, commandId, commandType, operateCardId);
    });
    if (executeCommandIndex !== CommonConstants.INVALID_VALUE) {
      this.executeCommandList.splice(executeCommandIndex, 1);
      log.showInfo('remove executed command id: %{public}s, type: %{public}d, cardId: %{public}s, index: %{public}d',
        commandId, commandType, operateCardId, executeCommandIndex);
      return true;
    }
    return false;
  }

  private isSameCommand(command: BaseCommand, commandId: string, commandType: number, operateCardId?: string): boolean {
    return command.commandId === commandId && command.commandType === commandType &&
      command.operateCardId === operateCardId;
  }

  /**
   * 清空未执行的命令
   */
  public clearCacheCommands(): void {
    this.cacheCommandMap?.clear();
    this.restCommandMap?.clear();
    this.pendingCommandMap?.clear();
  }
}