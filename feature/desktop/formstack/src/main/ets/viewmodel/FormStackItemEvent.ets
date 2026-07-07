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

import { image } from '@kit.ImageKit';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  PixelMapUtil,
  StartType
} from '@ohos/basicutils';
import {
  EventType,
  scbEventExclusiveManager,
  SCBTransitionController,
  SCBTransitionManager,
  AppData,
} from '@ohos/windowscene';
import {
  CardItemInfo,
  CloseAppManager,
  Extend1Data,
  FormRelationManager,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStackItemEventCb } from '@ohos/launchercommon/Index';
import CardLockManager from '@ohos/launchercommon/src/main/ets/manager/CardLockManager';
import { ErrorCardResultType, GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { FormStackHiSysEventUtil } from '../common/FormStackHiSysEventUtil';
import { FormStackClickEvent } from '../common/FormStackHiSysEventUtil';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackEventCb } from '../common/FormStackEventCb';
import { FormStackAnimateItem } from './FormStackAnimateItem';
import { SCBConstants } from '@ohos/commonconstants';

const TAG: string = 'FormStackItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export interface FormStackCommonInfo {
  formStackId: string;
  borderRadius: number;
  cardItem: CardItemInfo;
  eventCallback?: FormStackEventCb;
}

export class FormStackItemEvent implements FormStackItemEventCb {
  public mAnimateItem: FormStackAnimateItem = {} as FormStackAnimateItem;
  public mTransitionController?: SCBTransitionController;
  public mEventCallback?: FormStackEventCb;
  public mFormStackId: string = '';
  public mCardItem: CardItemInfo = new CardItemInfo();
  public mBorderRadius: number = 0;

  public getFormStackId(): string {
    return this.mFormStackId;
  }

  public initData(commonInfo: FormStackCommonInfo, animateItem: FormStackAnimateItem): void {
    this.mFormStackId = commonInfo.formStackId;
    this.mBorderRadius = commonInfo.borderRadius;
    this.mCardItem = commonInfo.cardItem;
    this.mEventCallback = commonInfo.eventCallback;
    this.mAnimateItem = animateItem;
    this.registerTransitionContrler(commonInfo.borderRadius);
  }

  public resetData(): void {
    this.mEventCallback = undefined;
    this.unRegisterTransitionController();
    this.mTransitionController = undefined;
  }

  public onError(errCode?: number, msg?: string): void {
    let errorMsg: string = `errorCode: ${errCode}, msg: ${msg}`;
    log.showError(errorMsg);
    this.mEventCallback?.onDeleteCardId(this.mCardItem.cardId, ErrorCardResultType.ONERROR, errorMsg);
  }

  public onUninstall(form: FormCallbackInfo): void {
    let errorMsg: string = `uninstall formStackItem success, formId: ${form?.idString} FormItemCardId: ${this.mCardItem.cardId}`;
    log.showWarn(errorMsg);
    this.mEventCallback?.onDeleteCardId(this.mCardItem.cardId, ErrorCardResultType.ONUNINSTALL, errorMsg);
  }

  public onUpdateId(newCardId: string): void {
    if (FormRelationManager.getInstance().isSceneBoardCard(this.mCardItem.bundleName, this.mCardItem.cardName)) {
      log.showInfo(`onUpdateId cardId: ${this.mCardItem.cardId}, is sceneBoard card, return!`)
      return;
    }

    log.showWarn(`onUpdateId newCard: ${newCardId}, currentCard: ${this.mCardItem.cardId}, ` +
      `extend1: ${this.mCardItem.extend1}.`);
    if (this.mCardItem.cardId !== newCardId || this.mCardItem.extend1) {
      this.mEventCallback?.onUpdateId(this.mCardItem, newCardId);
    }
  }

  public onClickForm(): void {
    log.showWarn(`onClickForm, cardId: ${this.mCardItem.cardId}.`);
    // 卡片上锁状态启动：需要监听主应用保护状态变化
    if (CardLockManager.getInstance().mainAppHasLock(this.mCardItem.bundleName) &&
      !CardLockManager.getInstance().getLockedCardIsReleased(this.mCardItem.bundleName, this.mCardItem.cardId)) {
      GlobalContext.getContext()?.eventHub.on(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_START,
        this.exitTransitionStartCallback);
    }
    if (!this.mCardItem.area || this.mCardItem.area.length < 2) {
      log.showWarn('the area of card item is invalid!');
      return;
    }

    const event: FormStackClickEvent = {
      formStackID: this.mFormStackId,
      area: this.mCardItem.area,
      topCardPackageName: this.mCardItem.bundleName,
      sourceType: Extend1Data.getCardSourceType(this.mCardItem.extend1),
    };

    FormStackHiSysEventUtil.reportClickEvent(event);
  }


  // 开始退出应用 动效开始
  private exitTransitionStartCallback: () => void = () => {
    log.showInfo('exitTransitionStartCallback done');
    GlobalContext.getContext()?.eventHub.off(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_START,
      this.exitTransitionStartCallback);
    if (CardLockManager.getInstance().mainAppHasLock(this.mCardItem.bundleName) &&
      !CardLockManager.getInstance().getLockedCardIsReleased(this.mCardItem.bundleName, this.mCardItem.cardId)) {
      log.showInfo('card is locked, update closeSnapshot abort.');     
      // 上锁状态 return;
      return;
    }
    try {
      let componentId: string = FormStackUtil.getFormComponentId(this.mCardItem);
      const img: image.PixelMap = componentSnapshot.getSync(componentId);
      PixelMapUtil.addName(img, 'FormStackItem_exit_image');
      CloseAppManager.getInstance().setCardStartSnapshot(componentId, img);
      img?.release();
    } catch (e) {
      log.showError(`set form snap fail: ${e?.code}`);
    }
  }


  public onUpdateName(name: string): void {
    log.showInfo(`onUpdateName cardId: ${this.mCardItem.cardId}, new name: ${name}.`);
    this.mEventCallback?.onUpdateName?.(this.mCardItem.cardId, name);
  }

  public onTouch(event: TouchEvent): void {
    if (event.type !== TouchType.Down) {
      return;
    }

    if (scbEventExclusiveManager.isExclusive(EventType.DESKTOP_CLICK)) {
      log.showWarn('formstack child item touch in exclusive scene!');
      return;
    }

    log.showWarn(`onTouch down, cardId: ${this.mCardItem.cardId}, start to snap img.`);
    // 如果透明度为0，就不截图
    if (this.mAnimateItem.mOpacity !== 0) {
      this.cacheSnapshotFormItem();
    }
  }

  public onLoadForm(cardId: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(cardId) || cardId === '0') {
      log.showWarn('preload form onLoad.');
      return;
    }

    this.mEventCallback?.onChildFormLoad(cardId);
  }

  private cacheSnapshotFormItem(): void {
    let componentId: string = FormStackUtil.getFormComponentId(this.mCardItem);
    if (CheckEmptyUtils.checkStrIsEmpty(componentId)) {
      log.showWarn('card componentId empty, do not need to cache snapshot image!');
      return;
    }

    FormStackUtil.snapImage(componentId, (pixmap: image.PixelMap) => {
      if (!FormStackUtil.isValidImage(pixmap)) {
        log.showError('snap formstack top card image invalid!');
        pixmap?.release();
        return;
      }
      PixelMapUtil.addName(pixmap, `FormStack_card_snapshot_${componentId}`);
      CloseAppManager.getInstance().setCardStartSnapshot(componentId, pixmap);
      pixmap?.release();
    });
  }

  private registerTransitionContrler(borderRadius: number): void {
    let appData: AppData = {
      bundleName: this.mCardItem.bundleName,
      abilityName: this.mCardItem.abilityName,
      appIconId: FormStackUtil.getFormComponentId(this.mCardItem),
      appIconNumber: Number(this.mCardItem.cardId),
      iconRadius: borderRadius,
      cardId: this.mCardItem.cardId,
      startAppType: StartType.CARD,
    };
    this.mTransitionController = {
      appData: appData,
      cardDimension: this.mCardItem.cardDimension,
      onActive: () => this.onActive(),
      onInactive: () => this.onInactive(),
    }

    SCBTransitionManager.getInstance().registerTransitionController(this.mTransitionController);
  }

  private unRegisterTransitionController(): void {
    SCBTransitionManager.getInstance().unRegisterTransitionController(this.mTransitionController);
  }

  private onActive(): void {
    log.showWarn(`onActive cardId: ${this.mCardItem.cardId}.`);
    this.mAnimateItem.mOpacity = 0;
  }

  private onInactive(): void {
    log.showWarn(`onInactive cardId: ${this.mCardItem.cardId}.`);

    this.mEventCallback?.onClearImages();
    if (!this.mEventCallback?.onIsAllowChangeOpacity()) {
      log.showWarn('not allow change opacity!');
      return;
    }

    this.mAnimateItem.mOpacity = 1;
  }
}