/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  FormStackItemBuildInterface,
  FormStackItemBuildParam,
  FormStackItemEventCb,
  FormStackItemViewData
} from '@ohos/launchercommon/Index';
import {
  CardItemInfo,
  CommonConstants,
  FormCommonUtil,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStackItemViewType } from '@ohos/launchercommon/src/main/ets/formstack/FormStackItemBuildInterface';
import { FormStackUtil } from '@ohos/formstack/src/main/ets/common/FormStackUtil';
import { CommonConfigData } from '@ohos/launchercommon/src/main/ets/formstack/FormStackItemBuildParam';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import {
  AiFormBasicParams,
  AiFormComponentBasicData,
  AiFormComponentBasicEvent,
  AiFormStackItemBuildInterface,
  CardNodeControllerManager,
} from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import { AiSuggestionComponent } from './AiSuggestionComponent';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { AiSuggestionFormManager } from '../manager/AiSuggestionFormManager';
import { AiSuggestionDataProcess } from '../helper/AiSuggestionDataProcess';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';

const TAG = 'AiSuggestionStackItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

export class AiSuggestionBuildItem implements FormStackItemBuildInterface {
  public type: FormStackItemViewType = FormStackItemViewType.AI_SUGGESTION;

  public isTypeMatch(layoutInfo: GridLayoutItemInfo): boolean {
    return layoutInfo.typeId === CommonConstants.TYPE_CARD &&
    AiSuggestionUtil.isVoiceAbilityForm(layoutInfo.bundleName, layoutInfo.abilityName);
  }

  public buildView(): WrappedBuilder<FormStackItemBuildParam[]> {
    return wrapBuilder(buildAiSuggestionItem);
  }
}

@Builder
export function buildAiSuggestionItem(param: FormStackItemBuildParam) {
  BaseForm({
    mConfigData: param.mConfigData,
    mEventCb: param.mEventCb,
    mViewData: param.mViewData,
  })
}

@Component
struct BaseForm {
  public readonly mConfigData: CommonConfigData = {} as CommonConfigData;
  public readonly mEventCb: FormStackItemEventCb = {} as FormStackItemEventCb;
  @ObjectLink mViewData: FormStackItemViewData;
  private cardController: CardNodeController | null = null;

  private getAiFormComponentBasicData(): AiFormComponentBasicData {
    return new AiFormComponentBasicData(
      this.mConfigData.mLayout.cardId as string,
      this.mViewData.mWidth,
      this.mViewData.mHeight,
      this.mConfigData.mLayout as object as GridLayoutItemInfo,
      this.mViewData.mBorderRadius,
      FormCommonUtil.getFormComponentId(this.mConfigData.mLayout as Object as CardItemInfo, false),
      this.mConfigData.mIsOuterDesktop,
      false,
      false,
      true
    );
  }

  private getAiFormComponentBasicEvent(): AiFormComponentBasicEvent {
    return {
      deleteForm: (playAnimation: boolean, formItem?: GridLayoutItemInfo, isOuter?: boolean): void => {
        const cardId: string | undefined = this.mConfigData.mLayout.cardId;
        // 判断是否移除堆叠里的语音助手建议主卡，如果是则需要修改场景卡的cardType
        let formStackInfo = AbilityFormUtil.getCardBelongFormStack(cardId);
        if (!FormStackUtil.isFormStackLayoutItemInvalid(formStackInfo)) {
          let cardList = formStackInfo?.layoutInfo[0];
          let cardItemInfo = cardList?.find(cardInfo => cardInfo.cardId === cardId);
          AiSuggestionDataProcess.onEventhubSetVoiceCardType(true, cardItemInfo, cardList ?? []);
        }

        this.mEventCb.onError();

        log.showWarn(`deleteForm cardId=${cardId}`);
        if (cardId) {
          AiSuggestionFormManager.getInstance().deleteCardInfoAfterAnimation(cardId);
        } else {
          log.showWarn('deleteForm cardId is empty.');
        }
      },
      updateAppName: (name: string): void => {
        this.mEventCb.onUpdateName(name);
      },
      updateFormId: (id: string): void => {
        this.mEventCb.onUpdateId(id);
      },
      isUseEffect: (useEffect: boolean): void => {
        this.mViewData.mUseEffect = useEffect;
      },
      isDuringAppExitAnim: (isAppExiting: boolean): void => {
        this.mViewData.mIsAppExiting = isAppExiting;
      },
      onItemHover: () => {},
      onItemSelected: () => {},
    };
  }

  aboutToAppear(): void {
    this.cardController = new CardNodeController(new AiFormBasicParams(
      this.getAiFormComponentBasicData(),
      this.getAiFormComponentBasicEvent()
    ), TAG);
  }

  aboutToDisappear(): void {
    this.cardController = null;
  }

  build() {
    NodeContainer(this.cardController)
      .borderRadius(this.mViewData.mBorderRadius)
      .useEffect(this.mViewData.mUseEffect)
      .rotate({
        x: 1,
        angle: this.mViewData.mRotateAngle,
        centerX: '50%',
        centerY: '0%'
      })
      .id(this.mConfigData.mCompId)
  }
}

// 语音助手节点复用Builder
export class AiSuggestionBuildNodeItem implements AiFormStackItemBuildInterface {
  public buildView(): WrappedBuilder<AiFormBasicParams[]> {
    return wrapBuilder(buildAiSuggestionNodeItem);
  }
}

@Builder
export function buildAiSuggestionNodeItem(param: AiFormBasicParams) {
  AiSuggestionComponent({
    defaultCardId: param.basicData.cardId,
    formItemWidth: param.basicData.width,
    formItemHeight: param.basicData.height,
    formItem: param.basicData.formItem,
    isFormStackChildItem: param.basicData.isFormStackChildItem,
    isOuterDesktop: param.basicData.isOuterDesktop,
    isLongPressZoomIn: param.basicData.isLongPressZoomIn,
    formBorderRadius: param.basicData.borderRadius,
    containerId: param.basicData.containerId,
    isCreateFormAnimation: param.basicData.isCreateFormAnimation,
    basicEvent: param.basicEvent,
  }).width('100%').height('100%').borderRadius(param.basicData.borderRadius)
}