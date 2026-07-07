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
import {
  CardItemInfo,
  FormLayoutCacheManager,
  GridLayoutItemInfo,
} from '@ohos/launchercommon';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { FormStackEventDonateInfo } from '../bean/FormStackEventDonateInfo';
import { FormStackEventInfo } from '../bean/FormStackEventInfo';
import { LauncherCardInfo } from '../bean/LauncherCardInfo';
import type { ResourceRspPayload } from '../bean/ResourceRspPayload';
import { DislikeOption, DispatchParamsConstant } from '../constants/DispatchParamsConstant';
import { OperateType } from '../constants/OperateType';
import { AiSuggestionEventReporter } from '../donate/AiSuggestionEventReporter';
import { DispatchParamsBuilder } from '../donate/DispatchParamsBuilder';
import { UnifiedSdk } from '../donate/impl/UnifiedSdk';
import type { IUnifiedSdk } from '../donate/IUnifiedSdk';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { AiSuggestionFormManager } from './AiSuggestionFormManager';

const TAG: string = 'AiSuggestionActionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

class ResUrlInfo {
  public resUrl: string = '';
}

interface GeneratedObjectLiteralInterface_1 {}


/**
 * 交互管理（数据捐赠、获取资源…）
 *
 * @since 2023-08-11
 */
export default class AiSuggestionActionManager {
  private static sInstance: AiSuggestionActionManager = new AiSuggestionActionManager();
  private mUniSdk: IUnifiedSdk;

  private constructor() {
    this.mUniSdk = UnifiedSdk.getInstance();
  }

  /**
   * Get instance
   *
   * @return Single instance
   */
  public static getInstance(): AiSuggestionActionManager {
    return AiSuggestionActionManager.sInstance;
  }

  /**
   * 点击卡片内的推荐服务
   *
   * @param childService 被点击的服务
   * @param parentForm 母卡片
   */
  public clickRecItem(childService: LauncherRecItem | undefined, parentForm: GridLayoutItemInfo): void {
    if (!childService || !parentForm) {
      log.showWarn('clickRecItem params is invalid');
      return;
    }

    log.showInfo(`clickRecItem parentForm=${parentForm.cardId}, childService ${childService.bundleName}_${childService.cardId}`);
    const params = this.buildPayloadParams(parentForm);
    params.serviceId = childService.serviceId;
    this.donateData(OperateType.CLICK, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 常驻此服务
   *
   * @param childService 被常驻的服务
   * @param parentForm 母卡片
   */
  public pinRecItem(childService: LauncherRecItem, parentForm: GridLayoutItemInfo): void {
    if (!childService || !parentForm) {
      log.showWarn('pinRecItem params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params.serviceId = childService.serviceId;
    this.donateData(OperateType.PIN, true, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 取消常驻
   *
   * @param childService 被取消常驻的服务
   * @param parentForm 母卡片
   */
  public unpinRecItem(childService: LauncherRecItem, parentForm: GridLayoutItemInfo): void {
    if (!childService || !parentForm) {
      log.showWarn('unpinRecItem params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params.serviceId = childService.serviceId;
    this.donateData(OperateType.UNPIN, true, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 移除卡片
   *
   * @param parentForm 母卡片
   * @param isSlideToDeleteForm 是否是侧滑移除
   */
  public removeForm(parentForm: GridLayoutItemInfo, isSlideToDeleteForm?: boolean): void {
    if (!parentForm) {
      log.showWarn('removeForm params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params.isSlideToDeleteForm = isSlideToDeleteForm ?? false;
    params.serviceIds = this.getServiceIdList(parentForm);
    this.donateData(OperateType.REMOVE, false, DispatchParamsBuilder.buildPayload(params));
  }

  private getServiceIdList(parentForm: GridLayoutItemInfo): string[] {
    const cardInfo: LauncherCardInfo | undefined = AiSuggestionFormManager.getInstance().getCardInfo(parentForm.cardId);
    const displayCardInfo: LauncherDisplayCardInfo | undefined = LauncherCardInfo.getDisplayCardInfo(cardInfo);
    if (!displayCardInfo || !displayCardInfo.recItems) {
      log.showError('getServiceIdList cardId: ${parentForm.cardId}, invalid displayCardInfo');
      return [];
    }
    return this.getRecItemServiceIds(displayCardInfo.recItems);
  }

  private getRecItemServiceIds(recItems: LauncherRecItem[]): string[] {
    const serviceIds: string[] = [];
    for (const item of recItems) {
      if (item.itemType === AiSuggestionConstants.TYPE_CARD || item.itemType === AiSuggestionConstants.TYPE_APP) {
        serviceIds.push(item.serviceId);
      } else if (item.itemType === AiSuggestionConstants.TYPE_APP_GROUP) {
        serviceIds.push(...this.getRecItemServiceIds(item.subLauncherRecItems));
      } else {
        log.showError(`getRecItemServiceIds unknown item type ${item.itemType}`);
      }
    }
    return serviceIds;
  }

  /**
   * 请求推荐服务
   *
   * @param parentForm 母卡片信息
   */
  public requestData(parentForm: GridLayoutItemInfo): void {
    if (!parentForm) {
      log.showWarn('requestData params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    this.donateData(OperateType.REQUEST_REC_SERVICE, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 语音助手建议屏布局变化
   */
  public screenChanged(): void {
    const obj: GeneratedObjectLiteralInterface_1 = {};
    this.donateData(OperateType.SCREEN_CHANGE, true, obj);
  }

  /**
   * 点击场景栏
   *
   * @param parentForm 母卡片信息
   */
  public clickPortfolioCard(parentForm: GridLayoutItemInfo): void {
    if (!parentForm) {
      log.showWarn('clickPortfolioCard params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    this.donateData(OperateType.CLICK_PORTFOLIO_CARD, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 不感兴趣此服务
   *
   * @param parentForm 母卡片
   * @param childService 选中的服务
   * @param option 不感兴趣选项
   */
  public dislikeService(parentForm: GridLayoutItemInfo, childService: LauncherRecItem, option?: DislikeOption): void {
    if (!parentForm || !childService) {
      log.showWarn('dislikeService params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params.serviceId = childService.serviceId;
    params['option'] = option === 0 ? 0 : 1;
    this.donateData(OperateType.DISLIKE_SERVICE, true, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 不感兴趣该场景
   *
   * @param parentForm 母卡片
   * @param option 不感兴趣选项
   */
  public dislikePortfolio(parentForm: GridLayoutItemInfo, option?: DislikeOption): void {
    if (!parentForm) {
      log.showWarn('dislikePortfolio params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params['option'] = option === 0 ? 0 : 1;
    this.donateData(OperateType.DISLIKE_PORTFOLIO, true, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 堆叠发生切换
   *
   * @param eventInfo 堆叠事件信息
   */
  public switchFormStack(eventInfo: FormStackEventInfo): void {
    if (CheckEmptyUtils.isEmpty(eventInfo?.stackId)) {
      log.showWarn('switchFormStack params is invalid');
      return;
    }

    const info: Record<string, Object> = {};
    info['stackId'] = eventInfo.stackId;
    if (eventInfo.preCardItemInfo) {
      const eventDonateInfo = new FormStackEventDonateInfo();
      eventDonateInfo.stackId = eventInfo.stackId;
      eventDonateInfo.actionName = eventInfo.actionName;
      eventDonateInfo.preCardItemInfo = eventInfo.preCardItemInfo;
      eventDonateInfo.page = eventInfo.preCardItemInfo.page;
      eventDonateInfo.column = eventInfo.preCardItemInfo.column;
      eventDonateInfo.row = eventInfo.preCardItemInfo.row;
      eventDonateInfo.cardItemInfo = eventInfo.cardItemInfo;
      eventDonateInfo.itemCount = eventInfo.cardItemInfoArr?.length;
      info['eventDonateInfo'] = eventDonateInfo;
    }
    this.donateData(OperateType.SWITCH_FORM_STACK, false,
      DispatchParamsBuilder.buildPayload(info));
  }

  /**
   * 分身点击引导语
   *
   * @param parentForm 母卡片信息
   * @param agentId 分身ID
   * @param guideId 引导语ID
   * @param intentId 意图ID
   * @param intentUuId 意图UUID
   */
  public clickAgentGuide(parentForm: GridLayoutItemInfo, agentId: string, guideId: string, intentId: string,
    intentUuId: string): void {
    if (!parentForm) {
      log.showWarn('clickAgentGuide params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params.agentId = agentId;
    params.guideId = guideId;
    params.intentId = intentId;
    params.intentUuId = intentUuId;
    this.donateData(OperateType.CLICK_AGENT_GUIDE, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 点击胶囊
   *
   * @param parentForm 母卡片信息
   * @param agentId 分身ID
   * @param chipId 胶囊ID
   * @param intentId 意图ID
   * @param intentUuId 意图UUID
   */
  public clickAgentChip(parentForm: GridLayoutItemInfo, agentId: string, chipId: string, intentId: string,
    intentUuId: string): void {
    if (!parentForm) {
      log.showWarn('clickAgentChip params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    params.agentId = agentId;
    params.chipId = chipId;
    params.intentId = intentId;
    params.intentUuId = intentUuId;
    this.donateData(OperateType.CLICK_AGENT_CHIP, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 点击热区
   *
   * @param parentForm 母卡片信息
   */
  public clickHotSpot(parentForm: GridLayoutItemInfo): void {
    if (!parentForm) {
      log.showWarn('clickHotSpot params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    this.donateData(OperateType.CLICK_HOT_SPOT, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 编辑场景和服务
   *
   * @param parentForm 母卡片
   */
  public editPortfolioAndService(parentForm: GridLayoutItemInfo): void {
    if (!parentForm) {
      log.showWarn('editPortfolioAndService params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    this.donateData(OperateType.EDIT_MENU, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 管理卡片
   *
   * @param parentForm 母卡片
   */
  public manageCard(parentForm: GridLayoutItemInfo): void {
    if (!parentForm) {
      log.showWarn('manageCard params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    this.donateData(OperateType.MANAGE_CARD, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 管理应用
   *
   * @param parentForm 母卡片
   */
  public manageApp(parentForm: GridLayoutItemInfo): void {
    if (!parentForm) {
      log.showWarn('manageApp params is invalid');
      return;
    }

    const params = this.buildPayloadParams(parentForm);
    this.donateData(OperateType.MANAGE_APP, false, DispatchParamsBuilder.buildPayload(params));
  }

  /**
   * 获取资源
   *
   * @param resUrl 资源url
   * @returns 资源响应载荷
   */
  public getResource(resUrl: string): Promise<ResourceRspPayload | undefined> {
    const urlInfo = new ResUrlInfo();
    urlInfo.resUrl = resUrl;
    return this.mUniSdk.dispatch(DispatchParamsBuilder.buildDispatchParams(OperateType.GET_RESOURCE, urlInfo))
      .then(payload => {
        const resource = payload as ResourceRspPayload;
        log.showInfo(`getResource resUrl = ${resUrl}, len = ${resource?.res?.length}`);
        return resource;
      })
      .catch(() => {
        log.showError(`getResource failed, resUrl = ${resUrl}`);
        return undefined;
      });
  }

  private buildPayloadParams(parentForm: GridLayoutItemInfo): Record<string, Object> {
    const launcherCardInfo = AbilityFormUtil.findParentFormByFormId(parentForm?.cardId);
    let stackId: string | undefined = undefined;
    if (parentForm?.container && parentForm?.container > 0) {
      const stackInfo = AbilityFormUtil.getCardBelongFormStack(parentForm?.cardId);
      stackId = stackInfo?.formStackId;
    }

    return {
      [DispatchParamsConstant.FORM_ID]: parentForm?.cardId ?? '',
      [DispatchParamsConstant.CARD_DIMENSION]: CardItemInfo.getCardDimension(parentForm?.area),
      [DispatchParamsConstant.REC_ID]: launcherCardInfo?.recId ?? '',
      [DispatchParamsConstant.SUB_REC_ID]: launcherCardInfo?.subRecId ?? 0,
      [DispatchParamsConstant.PORTFOLIO_ID]: launcherCardInfo?.portfolioInfo?.portfolioId ??
      AiSuggestionConstants.PORTFOLIO_ID_DEFAULT,
      [DispatchParamsConstant.PORTFOLIO_NAME]: launcherCardInfo?.portfolioInfo?.name ?? '',
      [DispatchParamsConstant.STACK_ID]: stackId ?? '',
      [DispatchParamsConstant.SCREEN_TYPE]: FormLayoutCacheManager.getInstance()
        .checkIfFormInExternalScreen(parentForm?.cardId) ? AiSuggestionConstants.EXTERNAL_SCREEN : '',
    };
  }

  /**
   * 捐赠数据
   *
   * @param operateType 操作类型
   * @param isRecordTime 是否记录时间
   */
  private donateData(operateType: OperateType, isRecordTime: boolean, payload: object): void {
    if (isRecordTime) {
      AiSuggestionEventReporter.getInstance().recordRequestTime();
    }
    this.mUniSdk.dispatch(DispatchParamsBuilder.buildDispatchParams(operateType, payload));
  }
}