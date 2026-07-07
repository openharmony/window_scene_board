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
  AiFormBasicParams,
  FormOccupyParams,
  CardNodeOption,
} from '../manager/CardNodeControllerManager';
import { FormCommonUtil } from '../utils/FormCommonUtil';
import CardLockManager from '../manager/CardLockManager';
import { CommonConstants } from '../constants/CommonConstants';

const TAG: string = 'CardNodeController';
const log: Logger = Logger.getLogHelper(LogDomain.FORM);
const HEXADECIMAL_VALUE: number = 36;
const PREFIX: string = 'cNode';

// 普通卡片
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
        // 记录formInfo
        controller.formInfo = form;
        // 需要更新节点缓存
        CardNodeControllerManager.updateCardNode(params.basicData.cardId, form.idString);
        CardNodeControllerManager.updateCardController(params.basicData.cardId, form.idString);
        // 记录新ID、报错删卡需要删除缓存节点
        params.basicData.cardId = form.idString;
        log.showInfo(TAG, `CardNodeController FormComponent acquried card id is = ${form.idString}`);
        // 更新cardId
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
      if (!form['isLocked']) { //sdk未更新、绕过TS校验
        CardLockManager.getInstance().addReleasedForm(params.basicData.bundleName, form.idString);
      }
      // 执行回调
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
      // 报错 都要移除节点緩存
      CardNodeControllerManager.destroyFormNodeByCardId(params.basicData.cardId);
      params.basicEvent.onError?.(error);
    })
    .onUninstall((form: FormCallbackInfo) => {
      log.showInfo(TAG, `FormComponent onUninstall form idString is = ${form.idString}, isLocked is = ${form.isLocked}, id is = ${form.id}`);
      // 删卡 移除节点緩存
      CardNodeControllerManager.destroyFormNodeByCardId(params.basicData.cardId);
      params.basicEvent.onUninstall?.(form);
    })
    .onTouch((event: TouchEvent) => {
      params.basicEvent.onTouch?.(event);
    })
}

function createCard(uiContext: UIContext, controller: CardNodeController):
  BuilderNode<[FormBasicParams | AiFormBasicParams]> | null {
  const params: FormBasicParams | AiFormBasicParams = controller.formParams as FormBasicParams | AiFormBasicParams;
  if (params instanceof AiFormBasicParams) { // 语音助手建议
    const cardNode: BuilderNode<[AiFormBasicParams]> | null =
      new BuilderNode<[AiFormBasicParams]>(uiContext);
    cardNode.build(CardNodeControllerManager.getAiSuggestionBuildItem()?.buildView(), params);
    return cardNode;
  }
  const cardNode : BuilderNode<[FormBasicParams]> | null =
    new BuilderNode<[FormBasicParams]>(uiContext);
  cardNode.build(wrapBuilder(cardBuilder), params);
  return cardNode;
}

function getOrCreateCard(uiContext: UIContext, controller: CardNodeController):
  BuilderNode<[FormBasicParams | AiFormBasicParams]> | null {
  const params: FormBasicParams | AiFormBasicParams | FormOccupyParams = controller.formParams;
  const controllerId: string = controller.uuid;
  // 普通卡片和语音助手建议区分不同的缓存
  if (params instanceof FormBasicParams || params instanceof AiFormBasicParams) {
    const getFn: Function = params instanceof FormBasicParams ?
      CardNodeControllerManager.getCardNode : CardNodeControllerManager.getAiCardNode;
    const setFn: Function = params instanceof FormBasicParams ?
      CardNodeControllerManager.setCardNode : CardNodeControllerManager.setAiCardNode;
    let ret: BuilderNode<[FormBasicParams | AiFormBasicParams]> | null | undefined =
      getFn(params.basicData.cardId);
    if (!ret) { // 创建节点
      ret = createCard(uiContext, controller);
      log.showInfo(TAG, `${controllerId} createNode; cardId = ${controller.getCardId()}; from = ${controller.from}; node = ${ret}`);
      setFn(params.basicData.cardId, ret);
    } else { // 更新节点
      log.showInfo(TAG, `${controllerId} reuseNode; cardId = ${controller.getCardId()}; from = ${controller.from}; node = ${ret}; controller.formInfo = ${controller.formInfo}`);
      if (params instanceof FormBasicParams && controller.formInfo) {
        // 触发生命周期(普通卡片才有)
        log.showInfo(TAG, `reuse node acquire lifecycle done`);
        params.basicEvent.onAcquired?.(controller.formInfo);
        params.basicEvent.onLoad?.();
      }
      ret.update(params);
      if (params instanceof FormBasicParams && !FormCommonUtil.isCardIdInvalid(params.basicData.cardId)) {
        // 更新want
        FormCommonUtil.requestFormWithParams(params.basicData.cardId, params.basicData.want.parameters as
          Record<string, Object>);
        if (params.basicData.updateLocation) {
          // 更新location
          const location: number = (params.basicData.want?.parameters?.[CommonConstants.FORM_LOCATION_KEY] as number);
          log.showInfo(TAG, `update location = ${location}`);
          // 更新location
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
    const getFn: Function = params.isAiCard ? CardNodeControllerManager.getAiCardNode :
      CardNodeControllerManager.getCardNode;
    const node: BuilderNode<[FormBasicParams | AiFormBasicParams]> | null = getFn(params.cardId);
    log.showInfo(TAG, `${controllerId} occupyNode; cardId = ${controller.getCardId()}; from = ${controller.from} ;node = ${node}`);
    return node;
  }
}

export class CardNodeController extends NodeController {
  private isShow: boolean = true;
  private isDestroyed: boolean = false;
  public formParams: FormBasicParams | AiFormBasicParams | FormOccupyParams = new FormOccupyParams('');
  public cardNodeOption: CardNodeOption = new CardNodeOption();
  public from: string = ''; // 来源
  public formInfo: FormCallbackInfo | null = null; // 卡片框架返回的结果
  public uuid: string = ''; // 身份标识
  // 链表
  public prev: CardNodeController | null = null; // 前一个节点
  public next: CardNodeController | null = null; // 后一个节点
  constructor(params: FormBasicParams | AiFormBasicParams | FormOccupyParams, from: string,
    cardNodeOption = new CardNodeOption()) {
    super();
    this.uuid = PREFIX + '_' + Math.random().toString(HEXADECIMAL_VALUE).substring(2);
    this.formParams = params;
    this.from = from;
    this.cardNodeOption = cardNodeOption;
  }

  getCardId(): string {
    let cardId = '';
    if (this.formParams instanceof FormBasicParams || this.formParams instanceof AiFormBasicParams) {
      cardId = this.formParams.basicData.cardId;
    } else {
      cardId = this.formParams.cardId;
    }
    return cardId;
  }

  onWillBind(): void {
    // makeNode方法调用之前会调用
    this.log();
    const params = this.formParams;
    let setFn: Function = () => {};
    let cardId: string = this.getCardId();
    let current: CardNodeController | null = null;
    if (params instanceof FormBasicParams || params instanceof AiFormBasicParams) {
      setFn = params instanceof FormBasicParams ?
        CardNodeControllerManager.setCardController : CardNodeControllerManager.setAiCardController;
      // 普通卡片or语音助手建议、卡片ID不能为空
      if (FormCommonUtil.isCardIdInvalid(params.basicData.cardId)) {
        params.basicData.cardId = FormCommonUtil.getCardUUID();
        cardId = params.basicData.cardId;
      } else {
        const getFn = params instanceof FormBasicParams ?
          CardNodeControllerManager.getCardController : CardNodeControllerManager.getAiCardController;
        current = getFn(cardId) as CardNodeController; // 当前节点挂载的controller
      }
    } else {
      // 参数为FormOccupyParams、表示抢占节点、堆叠展开场景
      const getFn = params.isAiCard ? CardNodeControllerManager.getAiCardController :
        CardNodeControllerManager.getCardController;
      setFn = params.isAiCard ? CardNodeControllerManager.setAiCardController :
        CardNodeControllerManager.setCardController;
      current = getFn(cardId) as CardNodeController; // 当前节点挂载的controller
      // 记录抢占的参数信息
      params.formParams = current?.formParams as (FormBasicParams | AiFormBasicParams);
    }
    const cur: string = current?.uuid ?? '';
    log.showInfo(TAG, `current = ${cur}; current.isDestroyed = ${current?.isDestroyed}`);
    if (current?.formInfo) { // 记录formInfo
      this.formInfo = current.formInfo;
    }
    const controllerId: string = this.uuid;
    if (current && !current.isDestroyed) { // 先销毁的、等待别人来挂载节点不需要记录
      if (!current.cardNodeOption.highestPriority || this.cardNodeOption.highestPriority) {
        // 当前节点的优先级非最高、or this的优先级最高、抢占节点
        current.toHide();
        log.showInfo(TAG, `set controller and take node; cardId = ${cardId}; controllerId = ${controllerId}`);
        setFn(cardId, this);
      } else { // 不抢占节点
        this.isShow = false;
      }
      while(current.next) { // 找到最后一个节点
        current = current.next as CardNodeController;
      }
      // 挂载链表
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
    let setFn: Function = this.formParams instanceof FormBasicParams ?
      CardNodeControllerManager.setCardController : CardNodeControllerManager.setAiCardController;
    if (this.formParams instanceof FormOccupyParams) {
      setFn = this.formParams.isAiCard ? CardNodeControllerManager.setAiCardController :
        CardNodeControllerManager.setCardController
    }
    if (this.isShow) {
      // 归还节点
      this.isShow = false;
      this.rebuild();
      log.showInfo(TAG,`${cur} return Node done`);
      // 优先找next
      if (this.next) { // 找到最后一个节点归还
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
      // FormComponent节点没有任何controller承载、检测缓存中是否还有相同CardId的数据、若没有则销毁
      Promise.resolve().then(() => {
        if (CardNodeControllerManager.cardIdInCache(cardId) && !this.cardNodeOption.destroyImmediately) {
          log.showInfo(TAG,`isolate FormComponent Node; cardId = ${cardId}`);
          // 清除桌面撤销卡片按钮
          AppStorage.setOrCreate('undoDragFormVisible', false);
          // 清除节点引用外部变量、防止内存泄漏
          let params: (AiFormBasicParams | FormBasicParams | undefined | FormOccupyParams) = this.formParams;
          if (params instanceof FormOccupyParams) {
            params = params?.formParams;
          }
          if (params) {
            params.basicEvent = {};
            if (params instanceof AiFormBasicParams) {
              CardNodeControllerManager.getAiCardNode(cardId)?.update(params);
            } else {
              CardNodeControllerManager.getCardNode(cardId)?.update(params);
            }
            if ((params instanceof AiFormBasicParams) && AppStorage.get<boolean>('isInTestEndPhrase')) {
                // 语音助手建议预置卡片在isInTestEndPhrase模式无法隔离(原因未知)、手动删除节点
              CardNodeControllerManager.destroyNodeByCardId(cardId);
            }
          }
          this.isDestroyed = true;
        } else {
          if (this.formParams instanceof FormBasicParams ||
            (this.formParams instanceof FormOccupyParams && !this.formParams.isAiCard)) {
            // FC 或者FC的抢占节点 只删除FC节点、语音助手会使用FC的cardId保存节点
            CardNodeControllerManager.destroyFormNodeByCardId(cardId);
          } else {
            // 语音助手删除全部节点
            CardNodeControllerManager.destroyNodeByCardId(cardId);
          }
          setFn(cardId, null);
        }
      });
    }
    // 解除绑定
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
    const aiFormKeys: string[] = CardNodeControllerManager.getAiFormKey();
    let detail = 'FORMS: ';
    for (let i = 0; i < formKeys.length; i++) {
      const key: string = formKeys[i];
      const controller = CardNodeControllerManager.getCardController(key) as CardNodeController;
      detail += `#${key}/${controller?.from};`;
    }
    detail += 'AI_FORMS: '
    for (let i = 0; i < aiFormKeys.length; i++) {
      const key: string = aiFormKeys[i];
      const controller = CardNodeControllerManager.getAiCardController(key) as CardNodeController;
      detail += `#${key}/${controller?.from};`;
    }
    log.showInfo(TAG, 'will bind: current = #%{public}s/%{public}s; size = %{public}d; %{public}s', this.getCardId(), this.from, CardNodeControllerManager.getNodeCacheSize(), detail);
  }
}