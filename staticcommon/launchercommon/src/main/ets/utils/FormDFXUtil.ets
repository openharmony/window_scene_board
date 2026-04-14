/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  FormLocationType,
  ErrorCardResultType,
  ReportCardFaultInformationEvent,
} from '@ohos/frameworkwrapper';
import type { CardItemInfo } from '../bean/CardItemInfo';
import { Extend1Data } from '../bean/Extend1Data';
import { FormCommonUtil } from './FormCommonUtil';
import { BuildCardEvent, FormHiSysEventReporter } from './FormHiSysEventReporter';

const TAG: string = 'FormDFXUtil';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class FormDFXUtil {
  public static reportBuildCard(cardItem: CardItemInfo, formId: string, location: FormLocationType): void {
    if (CheckEmptyUtils.isEmpty(cardItem)) {
      log.showWarn(TAG, 'report remove card UE event failed, cardItem is undefined.');
      return;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(formId)) {
      FormDFXUtil.reportBuildCardInvalidFormId(cardItem, formId, location);
    } else if (location === FormLocationType.DESKTOP) {
      FormDFXUtil.reportBuildCardSuccess(cardItem, formId, location);
    }
  }

  public static reportBuildCardInvalidFormId(cardItem: CardItemInfo, formId: string, location: FormLocationType): void {
    const event: ReportCardFaultInformationEvent = {
      faultInformation: HiDfxEventUtil.BUILD_CARD_INVALID_FORMID,
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: cardItem.moduleName,
      formName: cardItem.cardName,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1) ?? '',
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      location: location,
      resultType: ErrorCardResultType.INVALIDID,
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }

  public static reportBuildCardSuccess(cardItem: CardItemInfo, formId: string, location: FormLocationType): void {
    const event: BuildCardEvent = {
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: cardItem.moduleName,
      formName: cardItem.cardName,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1) ?? '',
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      location: location,
    };
    FormHiSysEventReporter.reportBuildCardSuccess(event);
  }

  public static reportBuildCardError(cardItem: CardItemInfo, location: FormLocationType,
    resultType: number, errorMsg?: string): void {
    if (!cardItem) {
      log.showWarn(TAG, 'report remove card UE event failed, cardItem is undefined.');
      return;
    }
    const event: ReportCardFaultInformationEvent = {
      faultInformation: HiDfxEventUtil.BUILD_CARD_ERROR,
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: cardItem.moduleName,
      formName: cardItem.cardName,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1) ?? '',
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      location: location,
      resultType: resultType,
      errorMsg: errorMsg,
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }

  public static reportBuildStackCardError(cardItem: CardItemInfo | undefined, formList: Array<CardItemInfo>,
    resultType: number, errorMsg?: string): void {
    if (!cardItem) {
      log.showWarn(TAG, 'report remove card UE event failed, cardItem is undefined.');
      return;
    }
    const event: ReportCardFaultInformationEvent = {
      faultInformation: HiDfxEventUtil.BUILD_STACK_CARD_ERROR,
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: cardItem.moduleName,
      formName: cardItem.cardName,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      location: FormLocationType.DESKTOP,
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1) ?? '',
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      resultType: resultType,
      errorMsg: errorMsg,
      formList: formList.map((item) => item.cardId),
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }

  public static reportBuildStackCardInvalidFormId(cardItem: CardItemInfo, formList: Array<CardItemInfo>): void {
    if (!cardItem) {
      log.showWarn(TAG, 'report remove card UE event failed, cardItem is undefined.');
      return;
    }
    const event: ReportCardFaultInformationEvent = {
      faultInformation: HiDfxEventUtil.BUILD_STACK_CARD_INVALID_FORMID,
      formId: `${cardItem.cardId}`,
      bundleName: cardItem.bundleName,
      moduleName: cardItem.moduleName,
      formName: cardItem.cardName,
      area: cardItem.area ?? [],
      position: FormCommonUtil.getReportPosition(cardItem),
      location: FormLocationType.DESKTOP,
      sourceType: Extend1Data.getCardSourceType(cardItem.extend1) ?? '',
      formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
      resultType: ErrorCardResultType.INVALIDID,
      formList: formList.map((item) => item.cardId),
    };
    HiDfxEventUtil.reportCardFaultInformation(event);
  }
}