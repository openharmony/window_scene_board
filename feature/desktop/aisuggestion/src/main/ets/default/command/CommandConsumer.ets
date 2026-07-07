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

import {
  ArrayUtils,
  DomainName,
  LogDomain,
  LogHelper,
  TraceUtil,
} from '@ohos/basicutils';
import { LauncherAnimUtil, RdbStoreManager } from '@ohos/launchercommon';
import { UserSwitchService } from '@ohos/screenlockcommon';
import { ScenePanelState } from '@ohos/windowscene';
import { LocalEventHandler } from '../event/handler/LocalEventHandler';
import { CommonUtil } from '../utils/CommonUtil';

import type { BaseCommand } from './BaseCommand';
import { CommandList } from './CommandList';

const TAG = 'CommandConsumer';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const COMMAND_EXECUTE_DELAY = 500;

// 创建堆叠或者添加卡片到堆叠，命令延迟刷新，避免同时创建多个卡片
const ADD_CARD_WAITING_TIME = 150;

// 刷新卡片延时，保证两次刷新命令间隔150ms
const UPDATE_CARD_DELAY = 150;

const DEBOUNCE_EXECUTE_COMMAND: number = 500;

/**
 * 命令消费
 *
 * @since 2024-02-04
 */
export class CommandConsumer {
  private static instance: CommandConsumer = new CommandConsumer();

  private commandList: CommandList = new CommandList();

  public debounceExecuteCommands: Function = CommonUtil.debounce<undefined>(() => {
    this.executeCommandWhenAppExit();
  }, DEBOUNCE_EXECUTE_COMMAND);

  /**
   * get CommandConsumer instance
   *
   * @return CommandConsumer instance
   */
  static getInstance(): CommandConsumer {
    return CommandConsumer.instance;
  }

  public cacheCommands(commandMap: Map<number, Map<string, BaseCommand[]>>): void {
    this.commandList.cacheCommands(commandMap);
    const commandIds: string = this.commandList.getCacheCommands()
      .map(command => command.toString())
      .join(',');
    log.showError(`cacheCommands commandIds = ${commandIds}`);
  }

  public checkAndExecuteCommands(): void {
    try {
      if (!this.canExecute()) {
        return;
      }
      this.commandList.setRestCommands();
      this.commandList.setPendingCommands();
      this.commandList.logPendingCommands();
      this.executePendingCommands();
    } catch (err) {
      log.error('checkAndExecuteCommands err', err?.message);
    }
  }

  private canExecute(): boolean {
    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      log.showError('currentUserId is not ForegroundUserId');
      return false;
    }
    if (RdbStoreManager.getInstance().isDisableInsert()) {
      // 系统迁移，桌面数据库正在升级过程中，不能往数据库插入数据
      log.showError('gridlayout_info db cannot insert data');
      return false;
    }
    if (this.commandList.isCommandExecuting()) {
      log.showError('pending commands executing');
      this.commandList.logExecutingCommands();
      return false;
    }
    if (this.isInBackground()) {
      log.showError('can not update card in background');
      return false;
    }
    if (!LocalEventHandler.getInstance().getIsEnabled()) {
      log.showError('can not operate form stack');
      return false;
    }
    return true;
  }

  private isInBackground(): boolean {
    let scenePanelState: ScenePanelState | undefined = AppStorage.get<ScenePanelState>('scenePanelState');
    return scenePanelState === ScenePanelState.RECENT;
  }

  /**
   * 优先执行完同一个commandId的command，当这个commandId没有待执行的command时，再刷新当前屏卡片，
   * 之后则取另一个commandId的缓存command执行
   * @param commandId 见BaseCommand中的commandId
   */
  private executePendingCommands(commandId?: string): void {
    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      log.showError('executePendingCommands currentUserId is not ForegroundUserId');
      return;
    }
    if (this.isInBackground()) {
      log.showError('executePendingCommands can not update card in background');
      return;
    }
    let pendingCommands: BaseCommand[] = [];
    const pendingCommand: BaseCommand | undefined = this.commandList.moveToNext(commandId);
    if (pendingCommand) {
      pendingCommands.push(pendingCommand);
    } else {
      this.commandList.getPendingCommands()
        .map(commandId => this.commandList.moveToNext(commandId))
        .forEach(command => {
          if (command) {
            pendingCommands.push(command);
          }
        });
    }
    if (ArrayUtils.isEmpty(pendingCommands)) {
      return;
    }
    const nextCommandStr = pendingCommands.map(command => command.toString()).join(',');
    log.showError(`executePendingCommands commandId=${commandId}, next command=[${nextCommandStr}]`);
    this.executeCommand(pendingCommands);
  }

  private executeCommand(pendingCommands: BaseCommand[]): void {
    if (ArrayUtils.isEmpty(pendingCommands)) {
      return;
    }
    this.doExecute(pendingCommands.shift());
    setTimeout(() => {
      this.executeCommand(pendingCommands);
    }, ADD_CARD_WAITING_TIME);
  }

  public finishCommand(commandId: string, commandType: number, operateCardId: string = ''): void {
    log.showInfo('ready finish id: %{public}s, type: %{public}d, cardId: %{public}s',
      commandId, commandType, operateCardId);
    let result: boolean = this.commandList.removeExecutedCommand(commandId, commandType, operateCardId);
    if (!result) {
      log.showWarn(`cannot find commandId: ${commandId}, commandType: ${commandType}`);
      return;
    }
    if (!this.commandList.isCommandExecuting()) {
      setTimeout(() => {
        log.showInfo('execute cache commands');
        this.checkAndExecuteCommands();
      }, UPDATE_CARD_DELAY);
    } else {
      this.executePendingCommands(commandId);
    }
  }

  private checkAndExecute(command: BaseCommand): void {
    if (LauncherAnimUtil.isUiThreadBusy()) {
      setTimeout(() => {
        this.checkAndExecute(command);
      }, COMMAND_EXECUTE_DELAY);
      return;
    }
    TraceUtil.traceOnce(DomainName.HOME, 'ExeCmd');
    command.executeTime = Date.now();
    command.execute();
  }

  private doExecute(command: BaseCommand | undefined): void {
    if (!command) {
      log.showError('doExecute command invalid');
      return;
    }
    if (command.delayTime > 0) {
      setTimeout(() => {
        this.checkAndExecute(command);
      }, command.delayTime);
    } else {
      this.checkAndExecute(command);
    }
  }

  public executeCommandWhenAppExit(): void {
    log.showError('executeCommandWhenAppExit');
    if (this.commandList.needExecutePendingCommands()) {
      this.executePendingCommands();
    } else {
      this.checkAndExecuteCommands();
    }
  }

  /**
   * 清空未执行的命令
   */
  public clearCacheCommands(): void {
    log.showInfo('clear cache command');
    this.commandList?.clearCacheCommands();
  }
}