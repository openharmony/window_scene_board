/**
 * Copyright (c) 2025-2025 Huawei Device Co., Ltd.
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
import { formHost } from '@kit.FormKit';
import { BuilderNode, NodeController, UIContext } from '@kit.ArkUI';
import { CheckEmptyUtils, Logger, LogDomain } from '@ohos/basicutils';
import {
  FormBasicParams,
  CardNodeControllerManager,
  FormOccupyParams,
  CardNodeOption,
  IErrorInfo,
} from '../manager/CardNodeControllerManager';
import { FormCommonUtil } from '../utils/FormCommonUtil';
import CardLockManager from '../manager/CardLockManager';
import { CommonConstants } from '../constants/CommonConstants';

const TAG: string = 'CardNodeController';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);
const HEXADECIMAL_VALUE: number = 36;
const PREFIX: string = 'cNode';

@Builder
function cardBuilder(params: FormBasicParams) {
  FormComponent({
    id: FormCommonUtil.transformCardId(params.basicData.cardId),
    name: params.basicData.cardName,
    bundle: params.basicData.bundleName,
    ability: params.basicData.abilityName,
    module: params.basicData.moduleName,
    dimension: params.basicData.cardDimension,
    want: params.basicData.want,
  })
    .id(params.basicData.compId)
    .borderRadius(params.basicData.borderRadius)
    .width(params.basicData.width)
    .height(params.basicData.height)
    .hoverEffect(params.basicData.hoverEffect ?? HoverEffect.Auto)
    .allowUpdate(true)
    .onAcquired((form: FormCallbackInfo) => {
      log.showInfo(TAG, `CardNodeController FormComponent params cardId = ${params.basicData.cardId};
                         acquried card form idString is = ${form.idString}, isLocked is = ${form.isLocked}, id is = ${form.id}`);
      if (CheckEmptyUtils.isEmpty(form)) {
        log.showError(TAG, 'CardNodeController FormComponent form item onAcquired formCallbackInfo invalid!');
        return;
      }
      if (CardNodeControllerManager.getCardController(params.basicData.cardId)) {
        const controller = CardNodeControllerManager.getCardController(params.basicData.cardId) as CardNodeController;
        controller.formInfo = form;
        CardNodeControllerManager.updateCardNode(params.basicData.cardId, form.idString);
        CardNodeControllerManager.updateCardController(params.basicData.cardId, form.idString);
        params.basicData.cardId = form.idString;
        log.showInfo(TAG, `CardNodeController FormComponent acquried card id is = ${form.idString}`);
        if (controller.formParams instanceof FormBasicParams) {
          controller.formParams.basicData.cardId = form.idString;
        }
        let prev = controller.prev as CardNodeController;
        while(prev) {
          if (prev.formParams instanceof FormBasicParams) {
            prev.formParams.basicData.cardId = form.idString;
            prev.formInfo = form;
          }
          prev = prev.prev as CardNodeController;
        }
        let next = controller.next as CardNodeController;
        while(next) {
          if (next.formParams instanceof FormBasicParams) {
            next.formParams.basicData.cardId = form.idString;
            next.formInfo = form;
          }
          next = next.next as CardNodeController;
        }
      }
      if (!form['isLocked']) {
        CardLockManager.getInstance().addReleasedForm(params.basicData.bundleName, form.idString);
      }
      params.basicEvent.onAcquired?.(form);
    })
    .onRouter(() => {
      log.showInfo(TAG, 'FormComponent onRouter');
      params.basicEvent.onRouter?.();
    })
    .onLoad(() => {
      log.showInfo(TAG, 'FormComponent onLoad');
      params.basicEvent.onLoad?.();
    })
    .onError((error) => {
      log.showError(TAG, `FormComponent onError msg = ${error?.msg}, errcode = ${error?.errcode};`);
      CardNodeControllerManager.destroyFormNodeByCardId(params.basicData.cardId);
      params.basicEvent.onError?.(error);
    })
    .onUninstall((form: FormCallbackInfo) => {
      log.showInfo(TAG, `FormComponent onUninstall form idString is = ${form.idString}, isLocked is = ${form.isLocked}, id is = ${form.id}`);
      CardNodeControllerManager.destroyFormNodeByCardId(params.basicData.cardId);
      params.basicEvent.onUninstall?.(form);
    })
    .onTouch((event: TouchEvent) => {
      params.basicEvent.onTouch?.(event);
    })
}

function createCard(uiContext: UIContext, controller: CardNodeController):
  BuilderNode<[FormBasicParams]> | null {
  const params: FormBasicParams = controller.formParams as FormBasicParams;
  const cardNode : BuilderNode<[FormBasicParams]> | null =
    new BuilderNode<[FormBasicParams]>(uiContext);
  cardNode.build(wrapBuilder(cardBuilder), params);
  return cardNode;
}

function getOrCreateCard(uiContext: UIContext, controller: CardNodeController):
  BuilderNode<[FormBasicParams]> | null {
  const params: FormBasicParams | FormOccupyParams = controller.formParams;
  const controllerId: string = controller.uuid;
  if (params instanceof FormBasicParams) {
    let ret: BuilderNode<[FormBasicParams]> | null | undefined =
      CardNodeControllerManager.getCardNode(params.basicData.cardId);
    if (!ret) {
      ret = createCard(uiContext, controller);
      log.showInfo(TAG, `${controllerId} createNode; cardId = ${controller.getCardId()}; from = ${controller.from}; node = ${ret}`);
      CardNodeControllerManager.setCardNode(params.basicData.cardId, ret);
    } else {
      log.showInfo(TAG, `${controllerId} reuseNode; cardId = ${controller.getCardId()}; from = ${controller.from}; node = ${ret}; controller.formInfo = ${controller.formInfo}`);
      if (controller.formInfo) {
        log.showInfo(TAG, `reuse node acquire lifecycle done`);
        params.basicEvent.onAcquired?.(controller.formInfo);
        params.basicEvent.onLoad?.();
      }
      ret.update(params);
      if (!FormCommonUtil.isCardIdInvalid(params.basicData.cardId)) {
        FormCommonUtil.requestFormWithParams(params.basicData.cardId, params.basicData.want.parameters as
          Record<string, Object>);
        if (params.basicData.updateLocation) {
          const location: number = (params.basicData.want?.parameters?.[CommonConstants.FORM_LOCATION_KEY] as number);
          log.showInfo(TAG, `update location = ${location}`);
          try {
            formHost.updateFormLocation(params.basicData.cardId, location);
          } catch (error) {
            log.showError(TAG, `updateFormLocation error, code: ${error?.code}, message: ${error?.message}`);
          }
        }
      }
    }
    return ret;
  } else {
    const node: BuilderNode<[FormBasicParams]> | null = CardNodeControllerManager.getCardNode(params.cardId);
    log.showInfo(TAG, `${controllerId} occupyNode; cardId = ${controller.getCardId()}; from = ${controller.from} ;node = ${node}`);
    return node;
  }
}

export class CardNodeController extends NodeController {
  private isShow: boolean = true;
  private isDestroyed: boolean = false;
  public formParams: FormBasicParams | FormOccupyParams = new FormOccupyParams('');
  public cardNodeOption: CardNodeOption = new CardNodeOption();
  public from: string = '';
  public formInfo: FormCallbackInfo | null = null;
  public uuid: string = '';
  public prev: CardNodeController | null = null;
  public next: CardNodeController | null = null;
  constructor(params: FormBasicParams | FormOccupyParams, from: string,
    cardNodeOption = new CardNodeOption()) {
    super();
    this.uuid = PREFIX + '_' + Math.random().toString(HEXADECIMAL_VALUE).substring(2);
    this.formParams = params;
    this.from = from;
    this.cardNodeOption = cardNodeOption;
  }

  getCardId(): string {
    let cardId = '';
    if (this.formParams instanceof FormBasicParams) {
      cardId = this.formParams.basicData.cardId;
    } else {
      cardId = this.formParams.cardId;
    }
    return cardId;
  }

  onWillBind(): void {
    this.log();
    const params = this.formParams;
    let setFn: Function = () => {};
    let cardId: string = this.getCardId();
    let current: CardNodeController | null = null;
    if (params instanceof FormBasicParams) {
      setFn = CardNodeControllerManager.setCardController;
      if (FormCommonUtil.isCardIdInvalid(params.basicData.cardId)) {
        params.basicData.cardId = FormCommonUtil.getCardUUID();
        cardId = params.basicData.cardId;
      } else {
        current = CardNodeControllerManager.getCardController(cardId) as CardNodeController;
      }
    } else {
      const getFn = CardNodeControllerManager.getCardController;
      setFn = CardNodeControllerManager.setCardController;
      current = getFn(cardId) as CardNodeController;
      params.formParams = current?.formParams as FormBasicParams;
    }
    const cur: string = current?.uuid ?? '';
    log.showInfo(TAG, `current = ${cur}; current.isDestroyed = ${current?.isDestroyed}`);
    if (current?.formInfo) {
      this.formInfo = current.formInfo;
    }
    const controllerId: string = this.uuid;
    if (current && !current.isDestroyed) {
      if (!current.cardNodeOption.highestPriority || this.cardNodeOption.highestPriority) {
        current.toHide();
        log.showInfo(TAG, `set controller and take node; cardId = ${cardId}; controllerId = ${controllerId}`);
        setFn(cardId, this);
      } else {
        this.isShow = false;
      }
      while(current.next) {
        current = current.next as CardNodeController;
      }
      this.prev = current;
      current.next = this;
    } else {
      log.showInfo(TAG, `set controller cardId = ${cardId}; controllerId = ${controllerId}`);
      setFn(cardId, this);
    }
  }

  onWillUnbind(): void {
    const cardId: string = this.getCardId();
    const cur: string = this.uuid;
    log.showInfo(TAG, `${cur} unBind: cardId = ${cardId}; from = ${this.from}; this.isShow = ${this.isShow}`);
    let setFn: Function = CardNodeControllerManager.setCardController;
    if (this.formParams instanceof FormOccupyParams) {
      setFn = CardNodeControllerManager.setCardController;
    }
    if (this.isShow) {
      this.isShow = false;
      this.rebuild();
      log.showInfo(TAG, `${cur} return Node done`);
      if (this.next) {
        let next = this.next;
        while(next.next) {
          next = next.next as CardNodeController;
        }
        setFn(cardId, next);
        next.toShow();
      } else if (this.prev) {
        setFn(cardId, this.prev);
        this.prev.toShow();
      }
    }
    const prev: string = this.prev?.uuid ?? '';
    const next: string = this.next?.uuid ?? '';
    log.showInfo(TAG, `${cur} prev = ${prev}; next = ${next}; destroyImmediately = ${this.cardNodeOption.destroyImmediately}`);
    if (!this.next && !this.prev) {
      Promise.resolve().then(() => {
        if (CardNodeControllerManager.cardIdInCache(cardId) && !this.cardNodeOption.destroyImmediately) {
          log.showInfo(TAG, `isolate FormComponent Node; cardId = ${cardId}`);
          AppStorage.setOrCreate('undoDragFormVisible', false);
          let params: (FormBasicParams | undefined | FormOccupyParams) = this.formParams;
          if (params instanceof FormOccupyParams) {
            params = params?.formParams;
          }
          if (params) {
            params.basicEvent = {
              onError: (_e: Object) => {},
              onAcquired: (_form: Object) => {},
              onRouter: () => {},
              onUninstall: (_form: Object) => {},
            };
            CardNodeControllerManager.getCardNode(cardId)?.update(params);
          }
          this.isDestroyed = true;
        } else {
          CardNodeControllerManager.destroyFormNodeByCardId(cardId);
          setFn(cardId, null);
        }
      });
    }
    if (this.next) {
      this.next.prev = this.prev;
    }
    if (this.prev) {
      this.prev.next = this.next;
    }
    this.prev = null;
    this.next = null;
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    const cur: string = this.uuid;
    if (!this.isShow) {
      log.showInfo(TAG, `${cur} makeNode: cardId = ${this.getCardId()};isShow = ${this.isShow};from = ${this.from}; node = null`);
      return null;
    }
    const node: FrameNode | null | undefined = getOrCreateCard(uiContext, this)?.getFrameNode();
    log.showInfo(TAG, `${cur} makeNode: cardId = ${this.getCardId()};isShow = ${this.isShow};from = ${this.from};node = ${node}`);
    return node || null;
  }

  toHide(): void {
    this.isShow = false;
    this.rebuild();
  }

  toShow(): void {
    this.isShow = true;
    this.rebuild();
  }

  log() {
    const formKeys: string[] = CardNodeControllerManager.getFormKey();
    let detail = 'FORMS: ';
    for (let i = 0; i < formKeys.length; i++) {
      const key: string = formKeys[i];
      const controller = CardNodeControllerManager.getCardController(key) as CardNodeController;
      detail += `#${key}/${controller?.from};`;
    }
    log.showInfo(TAG, 'will bind: current = #%{public}s/%{public}s; size = %{public}d; %{public}s', this.getCardId(), this.from, CardNodeControllerManager.getNodeCacheSize(), detail);
  }
}
