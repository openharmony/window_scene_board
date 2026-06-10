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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RectInfo } from '@ohos/basicutils';
import { WDefault } from '@ohos/screenlockcommon';
import {
  CmpPosWrapper,
  immeLiveStateShareMgr,
  ImmeLiveViewNameEnum,
  ImmersiveLiveAnimSceneEnum
} from '@ohos/screenlockcommon/Index';
import {
  ComponentAnimState,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { CardAnimType } from '../../../common/ImmersiveConstants';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { BaseAnimExecutor } from './BaseAnimExecutor';
import {
  ALPHA_PARAM,
  CARD_RADIUS,
  LIST_RADIUS,
  LIVE_LIST_SCALE_RATIO
} from '../ImmersiveLiveAnimManager';
import { CmpStateWrapper, ComponentTransformHelper } from '../../../common/helper/ComponentTransformHelper';
import { curves } from '@kit.ArkUI';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { sharedData } from '@ohos/systemuicommon/Index';

const TAG = 'ListCardAnimExecutor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 变换曲线
const CONVERT_CURVE = curves.interpolatingSpring(0, 1, 228, 24);
const IMME_DEFAULT_INDEX = 100;

/**
 * 实况列表&沉浸卡片动效执行器
 */
export class ListCardAnimExecutor extends BaseAnimExecutor {
  constructor(scene: ImmersiveLiveAnimSceneEnum) {
    super(scene);
  }

  complementAnimInfo(): void {
    let shareMgr = immeLiveStateShareMgr;
    // 组装列表动效状态信息和位置信息
    let rootWrapper = CmpStateWrapper.wrapper(shareMgr.getListRootCmpState() as ComponentAnimState);
    this.putStateInfo(ImmeLiveViewNameEnum.LIVE_LIST_ROOT, rootWrapper);
    shareMgr.getShareLiveData().forEach(entry => {
      let listItemState = shareMgr.getItemAnimStateMap()?.get(entry.hashCode);
      this.putStateInfo(entry.hashCode, CmpStateWrapper.wrapper(listItemState as ComponentAnimState));

      let posWrapper = this.getLiveListItemPosWrapper(entry.hashCode);
      this.putPosInfo(entry.hashCode, posWrapper);
    })
    // 组装卡片动效状态信息和位置信息
    let rootAnimState = shareMgr.getCardRootAnimState() as WidgetAnimState;
    this.putStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT, CmpStateWrapper.wrapper(rootAnimState));
    let contentState = shareMgr.getCardRootAnimState()?.getChildState(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    this.putStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, CmpStateWrapper.wrapper(contentState as WidgetAnimState));
    let contentPos = shareMgr.getCardContentPos();
    if (contentPos) {
      contentPos.radius = CARD_RADIUS;
    }
    this.putPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, CmpPosWrapper.wrapper(contentPos));
  }

  animate(): void {
    if (this.isForward) {
      if (SystemUICcmConfig.instance.isEnabledLive2) {
        this.forwardAnimateV2();
      } else {
        this.forwardAnimate();
      }
    } else {
      this.backwardAnimate();
    }
  }

  public preAnim(): void {
    (this.getStateInfo(this.keyCode as string) as CmpStateWrapper)?.setZIndex(IMME_DEFAULT_INDEX);
    super.preAnim();
  }

  public afterAnim(): void {
    super.afterAnim();
  }

  /**
   * 列表到卡片动效
   */
  private forwardAnimate() {
    let clickItemState = this.getStateInfo(this.keyCode as string);
    let clickItemPos = this.getPosInfo(this.keyCode as string);

    let cardContentState = this.getStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardContentPos = this.getPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardRootState = this.getStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT);

    ComponentTransformHelper.transformComponent(cardContentState, cardContentPos, clickItemPos);
    cardRootState?.setAlpha(WDefault.MIN_VALUE);
    animateTo({ curve: CONVERT_CURVE, onFinish: () => this.afterAnim() }, () => {
      ComponentTransformHelper.transformComponent(cardContentState, cardContentPos, cardContentPos);
      ComponentTransformHelper.transformComponent(clickItemState, clickItemPos, cardContentPos);
      this.handleOtherItemScale(LIVE_LIST_SCALE_RATIO);
    })

    animateTo(ALPHA_PARAM, () => {
      cardRootState?.setAlpha(WDefault.MAX_VALUE);
      this.handleItemAlpha(WDefault.MIN_VALUE);
    })
  }

  private forwardAnimateV2(): void {
    let clickItemPos: CmpPosWrapper | undefined;
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      clickItemPos = CmpPosWrapper.wrapper({
        globalX: sharedData.clickCardRect.x,
        globalY: sharedData.clickCardRect.y,
        width: sharedData.clickCardRect.width,
        height: sharedData.clickCardRect.height,
        radius: CARD_RADIUS,
      });
    } else {
      clickItemPos = this.getPosInfo(this.keyCode as string);
    }

    let cardContentState = this.getStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardContentPos = this.getPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardRootState = this.getStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT);

    ComponentTransformHelper.transformComponent(cardContentState, cardContentPos, clickItemPos);
    cardRootState?.setAlpha(WDefault.MIN_VALUE);
    animateTo({ curve: CONVERT_CURVE, onFinish: () => this.afterAnim() }, () => {
      ComponentTransformHelper.transformComponent(cardContentState, cardContentPos, cardContentPos);
    })
    animateTo(ALPHA_PARAM, () => {
      cardRootState?.setAlpha(WDefault.MAX_VALUE);
    })
  }

  /**
   * 卡片到列表动效
   */
  private backwardAnimate() {
    let clickItemState = this.getStateInfo(this.keyCode as string);
    let clickItemPos = this.getPosInfo(this.keyCode as string);
    let cardContentState = this.getStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardContentPos = this.getPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardRootState = this.getStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT);

    ComponentTransformHelper.transformComponent(clickItemState, clickItemPos, cardContentPos);
    this.handleOtherItemScale(LIVE_LIST_SCALE_RATIO);
    this.handleItemAlpha(WDefault.MIN_VALUE);
    animateTo({ curve: CONVERT_CURVE, onFinish: () => this.afterAnim() }, () => {
      ComponentTransformHelper.transformComponent(clickItemState, clickItemPos, clickItemPos);
      ComponentTransformHelper.transformComponent(cardContentState, cardContentPos, clickItemPos);
      this.handleOtherItemScale(WDefault.MAX_VALUE);
    })

    animateTo(ALPHA_PARAM, () => {
      cardRootState?.setAlpha(WDefault.MIN_VALUE);
      this.handleItemAlpha(WDefault.MAX_VALUE);
    })
  }

  private handleOtherItemScale(scale: number): void {
    immeLiveStateShareMgr.getItemAnimStateMap()?.forEach((state, key) => {
      if (key === this.keyCode) {
        return;
      }
      let itemState = this.getStateInfo(key);
      if (itemState) {
        itemState.setScale(scale, scale);
      }
    })
  }

  private handleItemAlpha(alpha: number): void {
    immeLiveStateShareMgr.getItemAnimStateMap()?.forEach((state, key) => {
      let itemState = this.getStateInfo(key);
      if (itemState) {
        itemState.setAlpha(alpha);
      }
    })
  }

  private getLiveListItemPosWrapper(hashcode: string): CmpPosWrapper {
    // 条目位置用实况面板条目共享位置，保持一致
    let itemRect: RectInfo | undefined = immeLiveStateShareMgr.getLiveListItemRect(hashcode);
    // 异常条目位置记录
    if ((itemRect?.width ?? 0) === 0) {
      log.showWarn(`getLiveListItemPosWrapper error resct: ${hashcode}`);
    }
    return CmpPosWrapper.wrapper({
      width: itemRect?.width,
      height: itemRect?.height,
      globalX: itemRect?.left,
      globalY: itemRect?.top,
      radius: LIST_RADIUS
    });
  }
}