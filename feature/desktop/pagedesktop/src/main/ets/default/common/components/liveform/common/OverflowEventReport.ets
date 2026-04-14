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
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { FormStyleConfig, FormViewModel } from '@ohos/form';
import {
  FormHiSysEventReporter,
  LaunchOverflowCardEvent,
  PauseOverflowCardEvent,
  ResumeOverflowCardEvent,
  DisconnectOverflowCardEvent,
} from '@ohos/launchercommon/src/main/ets/utils/FormHiSysEventReporter';
import { CardItemInfo, GameCardInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OverflowConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';

const TAG = 'OverflowEventReport';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class OverflowEventReport {
  /**
   * 上报 Overflow 卡片启动事件
   *
   * @param mFormItem 卡片基础信息
   * @param timeInterval 距 overflow 卡片前一次暂停时间的间隔时间
   * @param initDuration 初始化时长，拉起 UIExtensionAbility 所用时长
   * @param loadDuration 完成时延，从点击普通卡片到 overflow 卡片加载完成时间
   * @param reason overflow 卡片激活原因
   */
  public static reportLaunchOverflowCardEvent(mFormItem: CardItemInfo,
    timeInterval: number, initDuration: number, loadDuration: number, reason: number
  ): void {
    if (mFormItem.gameCardInfo === undefined) {
      log.showError(`report launch overflow card event failed, the value of necessary property is undefined` +
        `, formId:${mFormItem.cardId}`);
      return;
    }
    const event: LaunchOverflowCardEvent = {
      packageName: mFormItem.bundleName,
      dpSize: OverflowEventReport.getDpSize(mFormItem),
      cellSize: `${mFormItem.area?.[0]}*${mFormItem.area?.[1]}`,
      formId: String(mFormItem.cardId),
      moduleName: mFormItem.moduleName,
      formName: mFormItem.cardName,
      extensionType: OverflowEventReport.getExtensionType(mFormItem),
      extensionName: OverflowEventReport.getExtensionName(mFormItem.cardName, mFormItem.gameCardInfo),
      subBundleName: OverflowEventReport.getSubBundleName(mFormItem.gameCardInfo),
      timeInterval: timeInterval,
      initDuration: initDuration,
      loadDuration: loadDuration,
      reason: reason,
    };
    FormHiSysEventReporter.reportLaunchOverflowCard(event);
  }

  /**
   * 上报 Overflow 卡片恢复事件
   *
   * @param mFormItem 卡片基础信息
   * @param overflowFormResumeTime 卡片恢复时间
   * @param overflowFormPauseTime 卡片暂停时间
   */
  public static reportResumeOverflowCardEvent(mFormItem: CardItemInfo,
    overflowFormResumeTime: number, overflowFormPauseTime: number
  ): void {
    if (mFormItem.gameCardInfo === undefined) {
      log.showError(`report resume overflow card event failed, the value of necessary property is undefined` +
        `, formId:${mFormItem.cardId}`);
      return;
    }
    const event: ResumeOverflowCardEvent = {
      packageName: mFormItem.bundleName,
      dpSize: OverflowEventReport.getDpSize(mFormItem),
      cellSize: `${mFormItem.area?.[0]}*${mFormItem.area?.[1]}`,
      formId: String(mFormItem.cardId),
      moduleName: mFormItem.moduleName,
      formName: mFormItem.cardName,
      extensionType: OverflowEventReport.getExtensionType(mFormItem),
      extensionName: OverflowEventReport.getExtensionName(mFormItem.cardName, mFormItem.gameCardInfo),
      subBundleName: OverflowEventReport.getSubBundleName(mFormItem.gameCardInfo),
      timeInterval: overflowFormResumeTime - overflowFormPauseTime,
    };
    FormHiSysEventReporter.reportResumeOverflowCard(event);
  }

  /**
   * 上报 overflow 卡片暂停事件
   *
   * @param mFormItem 卡片基础信息
   * @param interval 持续时间，距 overflow 卡片前一次激活或恢复时间
   */
  public static reportPauseOverflowCardEvent(mFormItem: CardItemInfo, interval: number): void {
    if (mFormItem.gameCardInfo === undefined) {
      log.showError(`report pause overflow card event failed, the value of necessary property is undefined` +
        `, formId:${mFormItem.cardId}`);
      return;
    }
    const event: PauseOverflowCardEvent = {
      packageName: mFormItem.bundleName,
      dpSize: OverflowEventReport.getDpSize(mFormItem),
      cellSize: `${mFormItem.area?.[0]}*${mFormItem.area?.[1]}`,
      formId: String(mFormItem.cardId),
      moduleName: mFormItem.moduleName,
      formName: mFormItem.cardName,
      extensionType: OverflowEventReport.getExtensionType(mFormItem),
      extensionName: OverflowEventReport.getExtensionName(mFormItem.cardName, mFormItem.gameCardInfo),
      subBundleName: OverflowEventReport.getSubBundleName(mFormItem.gameCardInfo),
      timeInterval: interval,
    };
    FormHiSysEventReporter.reportPauseOverflowCard(event);
  }

  /**
   * 上报 overflow 卡片断开连接事件
   *
   * @param mFormItem 卡片基础信息
   * @param interval 持续时间，距 overflow 卡片前一次暂停时间
   * @param disconnectType 断开连接原因
   * @param totalUse overflow 卡片本次总使用时间
   */
  public static reportDisconnectOverflowCardEvent(mFormItem: CardItemInfo,
    interval: number, disconnectType: number, totalUse: number
  ): void {
    if (mFormItem.gameCardInfo === undefined) {
      log.showError(`report disconnect overflow card event failed, the value of necessary property is undefined` +
        `, formId:${mFormItem.cardId}`);
      return;
    }
    const event: DisconnectOverflowCardEvent = {
      packageName: mFormItem.bundleName,
      dpSize: OverflowEventReport.getDpSize(mFormItem),
      cellSize: `${mFormItem.area?.[0]}*${mFormItem.area?.[1]}`,
      formId: String(mFormItem.cardId),
      moduleName: mFormItem.moduleName,
      formName: mFormItem.cardName,
      extensionType: OverflowEventReport.getExtensionType(mFormItem),
      extensionName: OverflowEventReport.getExtensionName(mFormItem.cardName, mFormItem.gameCardInfo),
      subBundleName: OverflowEventReport.getSubBundleName(mFormItem.gameCardInfo),
      disconnectType: disconnectType,
      timeInterval: interval,
      totalUse: totalUse,
    };
    FormHiSysEventReporter.reportDisconnectOverflowCard(event);
  }

  private static getDpSize(mFormItem: CardItemInfo): string {
    const formViewModel: FormViewModel = FormViewModel.getInstance();
    const formStyleConfig: FormStyleConfig = formViewModel.getFormStyleConfig();
    let cardDimension: string = String(mFormItem.cardDimension);
    return (`${formStyleConfig.mFormWidth?.get(
      cardDimension)}*${formStyleConfig.mFormHeight?.get(cardDimension)}`);
  }

  private static getExtensionType(mFormItem: CardItemInfo): string {
    if (mFormItem.gameCardInfo?.extensionType === OverflowConstants.ANIMATION_TYPE) {
      return OverflowConstants.ANIMATION_TYPE;
    } else {
      return OverflowConstants.QUICK_TYPE_GAMECARD;
    }
  }

  private static getExtensionName(cardName: string, gameCardInfo: GameCardInfo): string {
    if (gameCardInfo.extensionType === OverflowConstants.ANIMATION_TYPE) {
      return cardName;
    } else {
      return gameCardInfo.formBindGame;
    }
  }

  private static getSubBundleName(gameCardInfo: GameCardInfo): string {
    if (gameCardInfo.extensionType === OverflowConstants.ANIMATION_TYPE) {
      return OverflowConstants.SUBBUNDLENAME_DEFAULT;
    } else {
      return gameCardInfo.subBundleName;
    }
  }
}