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
import { WDefault } from '@ohos/screenlockcommon';
import {
  CmpPosWrapper,
  immeLiveStateShareMgr,
  ImmeLiveViewNameEnum,
  ImmersiveLiveAnimSceneEnum
} from '@ohos/screenlockcommon/Index';
import {
  AnimDataScene,
  CapsuleHideScene,
  capsuleStateMgr,
  ComponentAnimState,
  LiveViewCapsuleStyle,
  LiveViewData,
  PropertyType
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { CardAnimType } from '../../../common/ImmersiveConstants';
import { BaseAnimExecutor } from './BaseAnimExecutor';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ALPHA_PARAM, FADE_PARAM, CAPSULE_RADIUS, CARD_RADIUS } from '../ImmersiveLiveAnimManager';
import { CmpStateWrapper, ComponentTransformHelper } from '../../../common/helper/ComponentTransformHelper';
import { CapsuleAnimName } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';
import { curves } from '@kit.ArkUI';

const TAG = 'CardCapsuleAnimExecutor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 变换曲线
const CONVERT_CURVE = curves.interpolatingSpring(0, 1, 228, 30);
/**
 * 卡片胶囊动效执行器
 */
export class CardCapsuleAnimExecutor extends BaseAnimExecutor {
  private isTop: boolean = false;
  private immersiveData?: LiveViewData;

  constructor(scene: ImmersiveLiveAnimSceneEnum) {
    super(scene);
  }

  setKeyCode(key: string | undefined): BaseAnimExecutor {
    this.keyCode = key;
    return this;
  }

  animate(): void {
    if (!this.isForward) {
      return;
    }
    let cardContentState = this.getStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let cardRootState = this.getStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT);
    let overlayCapsuleState = this.getStateInfo(CapsuleAnimName.CAPSULE_OVERLAY);
    let fadeCapsuleState = this.getStateInfo(CapsuleAnimName.CAPSULE_FADE);

    let cardContentPos = this.getPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE);
    let capsuleRootPos = this.getPosInfo(ImmeLiveViewNameEnum.LIVE_CAPSULE_ROOT);

    ComponentTransformHelper.transformComponent(overlayCapsuleState, capsuleRootPos, cardContentPos);
    animateTo({
      curve: CONVERT_CURVE,
      onFinish: () => this.afterAnim()
    }, () => {
      ComponentTransformHelper.transformComponent(cardContentState, cardContentPos, capsuleRootPos);
      ComponentTransformHelper.transformComponent(overlayCapsuleState, capsuleRootPos, capsuleRootPos);
    })
    animateTo(ALPHA_PARAM, () => {
      overlayCapsuleState?.setAlpha(WDefault.MAX_VALUE);
      cardRootState?.setAlpha(WDefault.MIN_VALUE);
    })

    const shareData = immeLiveStateShareMgr.getShareLiveData();
    if (this.isTop && shareData.length > 1) {
      // 收回顶部沉浸实况卡片, 原顶部胶囊做逐渐透明动效
      animateTo(FADE_PARAM, () => {
        fadeCapsuleState?.setAlpha(WDefault.MIN_VALUE);
        fadeCapsuleState?.setWidth(LiveViewCapsuleStyle.CAPSULE_STACK_BORDER_WIDTH);
      })
    }
  }

  public preAnim(): void {
    this.prepareTargetCapsule();
    super.preAnim();
  }

  public afterAnim(): void {
    if (!this.isAnim) {
      return;
    }
    this.resetTargetCapsule();
    super.afterAnim();
  }

  public checkCondition(): boolean {
    if (!this.immersiveData) {
      log.showWarn('checkCondition immeData is null');
      return false;
    }
    return super.checkCondition();
  }

  complementAnimInfo(): void {
    let shareMgr = immeLiveStateShareMgr;
    // 沉浸数据是否是顶部胶囊
    this.isTop = capsuleStateMgr.getCapsuleState().topCapsule?.hashCode === this.keyCode;
    this.immersiveData = shareMgr.getShareLiveData().find(entry => {
      return entry.hashCode === this.keyCode;
    });
    // 组装胶囊动效状态和位置信息
    let rootCapsule = shareMgr.getBannerCapsuleCmpState() as ComponentAnimState;
    let realContentCapsule = capsuleStateMgr.getCapsuleState().topCapsule?.capsule?.animState as ComponentAnimState;
    let realShadowCapsule = capsuleStateMgr.getCapsuleState().shadowCapsule?.capsule?.animState as ComponentAnimState;
    let overlayCapsule = rootCapsule.getChildAnimState(CapsuleAnimName.CAPSULE_OVERLAY) as ComponentAnimState;
    let fadeCapsule = rootCapsule.getChildAnimState(CapsuleAnimName.CAPSULE_CONTENT) as ComponentAnimState;

    this.putStateInfo(ImmeLiveViewNameEnum.LIVE_CAPSULE_ROOT, CmpStateWrapper.wrapper(rootCapsule));
    this.putStateInfo(CapsuleAnimName.CAPSULE_CONTENT, CmpStateWrapper.wrapper(realContentCapsule));
    this.putStateInfo(CapsuleAnimName.CAPSULE_SHADOW, CmpStateWrapper.wrapper(realShadowCapsule));
    this.putStateInfo(CapsuleAnimName.CAPSULE_OVERLAY, CmpStateWrapper.wrapper(overlayCapsule));
    this.putStateInfo(CapsuleAnimName.CAPSULE_FADE, CmpStateWrapper.wrapper(fadeCapsule));

    this.putPosInfo(ImmeLiveViewNameEnum.LIVE_CAPSULE_ROOT, this.getTargetCapsulePosition());
    // 组装卡片动效状态和位置信息
    let rootAnimState = shareMgr.getCardRootAnimState() as WidgetAnimState;
    this.putStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT, CmpStateWrapper.wrapper(rootAnimState));
    let contentCapState = rootAnimState?.getChildState(CardAnimType.CARD_LIVE_CONTENT_TYPE) as WidgetAnimState;
    this.putStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, CmpStateWrapper.wrapper(contentCapState));
    let pos = shareMgr.getCardContentPos();
    if (pos) {
      pos.radius = CARD_RADIUS;
    }
    let contentCapPos = CmpPosWrapper.wrapper(pos);
    this.putPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, contentCapPos);
  }

  private prepareTargetCapsule() {
    let capsuleState = capsuleStateMgr.getCapsuleState();
    capsuleState.animOverlayCapsule = this.immersiveData;
    this.getStateInfo(CapsuleAnimName.CAPSULE_OVERLAY)?.setAlpha(WDefault.MIN_VALUE);
    const shareData = immeLiveStateShareMgr.getShareLiveData();

    capsuleStateMgr.getCapsuleState()?.setAnimCapsuleData(AnimDataScene.SCENE_IMME_LIVE, shareData);
    if (this.isTop) {
      capsuleState.animOverlayCapsule = capsuleState.topCapsule;
      this.getStateInfo(CapsuleAnimName.CAPSULE_OVERLAY)?.setAlpha(WDefault.MIN_VALUE);
      // 隐藏真实胶囊
      this.getStateInfo(CapsuleAnimName.CAPSULE_CONTENT)?.setAlpha(WDefault.MIN_VALUE);

      if (shareData.length > 1) {
        capsuleState.animContentCapsule = capsuleState.shadowCapsule;
        let rootCapsule = immeLiveStateShareMgr.getBannerCapsuleCmpState();
        let contentFadeCapsule = rootCapsule?.getChildAnimState(CapsuleAnimName.CAPSULE_CONTENT);
        contentFadeCapsule?.setPropertyValue(PropertyType.ALPHA, WDefault.MAX_VALUE);
        contentFadeCapsule?.setPropertyValue(PropertyType.WIDTH, shareData.length === 2 ?
          LiveViewCapsuleStyle.CAPSULE_BORDER_WIDTH : LiveViewCapsuleStyle.CAPSULE_STACK_BORDER_WIDTH);
      } else {
        // 只有一个胶囊时，overlay胶囊实现动效，content动效胶囊隐藏
        this.getStateInfo(CapsuleAnimName.CAPSULE_FADE)?.setAlpha(WDefault.MIN_VALUE);
      }
    } else {
      capsuleState.animOverlayCapsule = capsuleState.shadowCapsule;
      this.getStateInfo(CapsuleAnimName.CAPSULE_OVERLAY)?.setAlpha(WDefault.MIN_VALUE);
    }
  }

  private resetTargetCapsule() {
    this.immersiveData = undefined;
    capsuleStateMgr.getCapsuleState().animOverlayCapsule = undefined;
    if (this.isTop) {
      this.getStateInfo(CapsuleAnimName.CAPSULE_CONTENT)?.setAlpha(WDefault.MAX_VALUE);
      // content动效胶囊复位
      this.getStateInfo(CapsuleAnimName.CAPSULE_FADE)?.setAlpha(WDefault.MAX_VALUE);
    }
    // banner面板不参与动效的胶囊状态清除
    let rootCapsule = immeLiveStateShareMgr.getBannerCapsuleCmpState();
    let bannerContentCapsule = rootCapsule?.getChildAnimState(CapsuleAnimName.CAPSULE_CONTENT);
    let bannerShadowCapsule = rootCapsule?.getChildAnimState(CapsuleAnimName.CAPSULE_SHADOW);
    bannerContentCapsule?.clearProperty(PropertyType.ALPHA);
    bannerShadowCapsule?.clearProperty(PropertyType.ALPHA);
  }

  private getTargetCapsulePosition(): CmpPosWrapper {
    let capsulePos = capsuleStateMgr.getCapsulePosition();
    let capsuleWidth = capsuleStateMgr.getCapsuleState().getCapsuleWidth();
    // 动效前可能存在无胶囊数据高度为0
    if (capsulePos.height === 0) {
      capsulePos.height = LiveViewCapsuleStyle.CAPSULE_HEIGHT;
    }
    return CmpPosWrapper.wrapper({
      width: capsuleWidth,
      height: capsulePos.height,
      globalX: capsulePos.left,
      globalY: capsulePos.top,
      radius: CAPSULE_RADIUS
    });
  }
}