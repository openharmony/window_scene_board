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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { BaseCommand } from './BaseCommand';

const TAG = 'CommandValidator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 模拟命令执行的结果，判断结果是否符合预期
 *
 * @since 2024-07-14
 */
export class CommandValidator {
  public static filterInvalidCommand(cacheCommandMap: Map<Number, Map<string, BaseCommand[]>>): void {
    const operateFormStackCommandMap: Map<string, BaseCommand[]> =
      cacheCommandMap?.get(AiSuggestionUpdateConstants.GroupType.OPERATE_STACKS) ?? new Map();
    if (!operateFormStackCommandMap) {
      return;
    }
    operateFormStackCommandMap.forEach((commands: BaseCommand[], stackId: string) => {
      // 执行操作堆叠命令后，堆叠内语音助手建议卡片结果
      const result = CommandValidator.getArrangeResult(commands, stackId);

      // 检查结果中有没有重复的卡片
      if (!CommandValidator.hasDuplicateTags(result)) {
        return;
      }
      const restCommands = CommandValidator.getRestCommands(commands);
      operateFormStackCommandMap.set(stackId, restCommands);
    });
  }

  private static getRestCommands(commands: BaseCommand[]): BaseCommand[] {
    const restCommands: BaseCommand[] = [];
    const filterCommands: BaseCommand[] = [];
    for (let command of commands) {
      if (!command) {
        continue;
      }
      // 过滤添加卡片的命令
      if (command.commandType === AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK ||
        command.commandType === AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP_AFTER_ADD_CARD_TO_STACK) {
        filterCommands.push(command);
        continue;
      }
      if (command.commandType === AiSuggestionUpdateConstants.CommandType.UPDATE_CARD) {
        const launcherCardInfo: LauncherCardInfo = command.data as LauncherCardInfo;
        if (LauncherCardInfo.isMainCard(launcherCardInfo)) {
          restCommands.push(command);
        } else {
          filterCommands.push(command);
        }
        continue;
      }
      restCommands.push(command);
    }
    const filterCommandStr: string = filterCommands.map(command => command.toString()).join(',');
    log.showError(`filter invalid command ${filterCommandStr}`);
    return restCommands;
  }

  private static getUniqueIdMap(stackId: string, layoutInfo: GridLayoutItemInfo[]): Map<string, number> {
    // 获取堆叠内语音助手建议卡片
    let voiceItems: GridLayoutItemInfo[] =
      layoutInfo.filter(info => AiSuggestionUtil.isVoiceAbilityForm(info.bundleName, info.abilityName)) ?? [];

    const uniqueIdMap: Map<string, number> = new Map();
    for (const item of voiceItems) {
      const uniqueId = ExtraData.getCardUniqueTag(item) ?? ExtraData.getPortfolioId(item);
      const count = uniqueIdMap.get(uniqueId) ?? 0;
      uniqueIdMap.set(uniqueId, count + 1);
    }
    // 记录当前的卡片列表
    const originalUniTagList: string =
      `${Array.from(uniqueIdMap).map(entry => `[${entry[0]}, ${entry[1]}]`).join(',')}`;
    log.showInfo(`stackId: ${stackId}, original cardUniqueTag: ${originalUniTagList}`);
    return uniqueIdMap;
  }

  private static getArrangeResult(commands: BaseCommand[], stackId: string): Map<string, number> {
    const layoutInfo = AbilityFormUtil.getFormStackInfoByFormStackId(stackId);
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      log.showError(`getArrangeResult invalid layoutInfo, stackId: ${stackId}}`);
      return new Map();
    }
    // 获取uniqueId列表
    const uniqueIdMap = CommandValidator.getUniqueIdMap(stackId, layoutInfo);
    commands.forEach(command => {
      switch (command.commandType) {
        case AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK:
          CommandValidator.preExecuteAddCommand(command, stackId, uniqueIdMap);
          break;
        case AiSuggestionUpdateConstants.CommandType.DELETE_CARD_FROM_STACK:
          CommandValidator.preExecuteDeleteCommand(command, layoutInfo, stackId, uniqueIdMap);
          break;
        case AiSuggestionUpdateConstants.CommandType.UPDATE_CARD:
          CommandValidator.preExecuteUpdateCommand(command, layoutInfo, stackId, uniqueIdMap);
          break;
        default:
          break;
      }
    });
    const finalUniTagList: string =
      `${Array.from(uniqueIdMap.keys()).join(',')}_${Array.from(uniqueIdMap.values()).join(',')}`;
    log.showInfo(`stackId: ${stackId}, final cardUniqueTag: ${finalUniTagList}`);
    return uniqueIdMap;
  }

  private static preExecuteAddCommand(command: BaseCommand, stackId: string,
    uniqueIdMap: Map<string, number>): void {
    let addCardMap: Map<string, LauncherCardInfo[]> = command.data as Map<string, LauncherCardInfo[]>;
    const addCardsUniqueTags: string[] =
      Array.from(addCardMap.values()).flat().map(launcherCardInfo => launcherCardInfo.cardUniqueTag ??
        launcherCardInfo.portfolioInfo?.portfolioId);
    log.showInfo(`stackId: ${stackId}, addCards -> ${addCardsUniqueTags}`);
    for (let tag of addCardsUniqueTags) {
      const count = uniqueIdMap.get(tag) ?? 0;
      uniqueIdMap.set(tag, count + 1);
    }
  }

  private static preExecuteDeleteCommand(command: BaseCommand, layoutInfo: GridLayoutItemInfo[], stackId: string,
    uniqueIdMap: Map<string, number>): void {
    let deleteCards: LauncherCardInfo[] = command.data as LauncherCardInfo[];
    const deleteCardsUniqueTags: string[] =
      deleteCards.filter(deleteCard => CommandValidator.isExistInFormStack(layoutInfo, deleteCard.operateFormId))
        .map(launcherCardInfo => launcherCardInfo.cardUniqueTag ?? launcherCardInfo.portfolioInfo?.portfolioId);
    log.showInfo(`stackId: ${stackId}, deleteCards -> ${deleteCardsUniqueTags}`);
    for (let tag of deleteCardsUniqueTags) {
      const count = uniqueIdMap.get(tag) ?? 0;
      uniqueIdMap.set(tag, count - 1);
    }
  }

  private static preExecuteUpdateCommand(command: BaseCommand, layoutInfo: GridLayoutItemInfo[], stackId: string,
    uniqueIdMap: Map<string, number>): void {
    // 需要更新的内容
    const newCardInfo: LauncherCardInfo = command.data as LauncherCardInfo;
    const newCardTag = newCardInfo.cardUniqueTag ?? newCardInfo.portfolioInfo?.portfolioId;

    // 之前的内容
    const oldCardInfo: GridLayoutItemInfo | undefined =
      layoutInfo.find(info => info.cardId === newCardInfo.operateFormId);
    let oldCardTag: string = 'default';
    if (oldCardInfo) {
      oldCardTag = ExtraData.getCardUniqueTag(oldCardInfo) ?? ExtraData.getPortfolioId(oldCardInfo);
    }
    log.showInfo(`stackId: ${stackId}, updateCard: ${oldCardTag} -> ${newCardTag}`);

    // 刷新成不同的卡片
    if (newCardTag !== oldCardTag) {
      const oldCardTagCount = uniqueIdMap.get(oldCardTag) ?? 0;
      uniqueIdMap.set(oldCardTag, oldCardTagCount - 1);

      const newCardTagCount = uniqueIdMap.get(newCardTag) ?? 0;
      uniqueIdMap.set(newCardTag, newCardTagCount + 1);
    }
  }

  private static isExistInFormStack(layoutInfo: GridLayoutItemInfo[], deleteCardId: string): boolean {
    return layoutInfo.findIndex(info => info.cardId === deleteCardId) !== -1;
  }

  private static hasDuplicateTags(uniqueIdMap: Map<string, number>): boolean {
    for (const entry of uniqueIdMap) {
      const cardUniqueTag = entry[0];
      const count = entry[1];
      if (cardUniqueTag === 'default') {
        continue;
      }
      if (count > 1) {
        return true;
      }
    }
    return false;
  }
}