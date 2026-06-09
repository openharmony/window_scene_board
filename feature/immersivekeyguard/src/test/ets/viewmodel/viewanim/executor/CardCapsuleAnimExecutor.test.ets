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
import { CmpPosWrapper, ImmeLiveViewNameEnum, ImmersiveLiveAnimSceneEnum } from '@ohos/screenlockcommon/Index';
import { afterEach, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { CmpStateWrapper } from '../../../../../../../main/ets/common/helper/ComponentTransformHelper';
import { ComponentAnimState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import {
  CardCapsuleAnimExecutor
} from '../../../../../../../main/ets/viewmodel/viewanim/executor/CardCapsuleAnimExecutor';
import { CardAnimType } from '../../../../../../../main/ets/common/ImmersiveConstants';
import { CapsuleAnimName } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';

/**
 * 胶囊卡片动效执行器测试用例
 */
export default function CardCapsuleAnimExecutorTest() {
  let baseAnimExecutor: CardCapsuleAnimExecutor =
    new CardCapsuleAnimExecutor(ImmersiveLiveAnimSceneEnum.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM);
  let mockCardStateWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('RootCard'));
  let mockCardContentWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('ContentCard'));
  let mockCardRootWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('ImageCard'));
  let mockCapsuleRootWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('RootCapsule'));
  let mockCapsuleContentWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('ContentCapsule'));
  let mockCapsuleShadowWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('ShadowCapsule'));
  let mockCapsulePosWrapper: CmpPosWrapper = CmpPosWrapper.wrapperProperty(10, 60, 0, 0, 5);
  let mockCardPosWrapper: CmpPosWrapper = CmpPosWrapper.wrapperProperty(30, 180, 60, 60, 5);

  // 组装胶囊信息
  baseAnimExecutor.putStateInfo(ImmeLiveViewNameEnum.LIVE_CAPSULE_ROOT, mockCapsuleRootWrapper);
  baseAnimExecutor.putStateInfo(CapsuleAnimName.CAPSULE_CONTENT, mockCapsuleContentWrapper);
  baseAnimExecutor.putStateInfo(CapsuleAnimName.CAPSULE_SHADOW, mockCapsuleShadowWrapper);
  baseAnimExecutor.putPosInfo(ImmeLiveViewNameEnum.LIVE_CAPSULE_ROOT, mockCapsulePosWrapper);

  // 组装卡片信息
  baseAnimExecutor.putStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT, mockCardStateWrapper);
  baseAnimExecutor.putStateInfo(CardAnimType.CARD_LIVE_IMAGE_TYPE, mockCardContentWrapper);
  baseAnimExecutor.putStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, mockCardRootWrapper);
  baseAnimExecutor.putPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, mockCardPosWrapper);

  describe('CardCapsuleAnimExecutorTest', () => {
    beforeEach(() => {
    });
    afterEach(() => {
    });

    it('putStateInfo', Level.LEVEL0, (): void => {
      baseAnimExecutor.putStateInfo("testKey", mockCardStateWrapper);
      let result: ESObject = baseAnimExecutor.getStateInfo("testKey");
      expect(result).assertDeepEquals(mockCardStateWrapper);
    });

    it('putPosInfo', Level.LEVEL0, (): void => {
      baseAnimExecutor.putPosInfo("testKey", mockCapsulePosWrapper);
      let result: ESObject = baseAnimExecutor.getStateInfo("testKey");
      expect(result).assertDeepEquals(mockCapsulePosWrapper);
    });

    it('checkCondition', Level.LEVEL0, (): void => {
      baseAnimExecutor.putStateInfo("testKey", mockCardStateWrapper);
      baseAnimExecutor.putPosInfo("testKey", mockCapsulePosWrapper);
      expect(baseAnimExecutor.checkCondition()).assertTrue();
    });

    it('complementAnimInfo', Level.LEVEL0, (): void => {
      baseAnimExecutor.complementAnimInfo();
      expect(true).assertTrue();
    });

    it('animate', Level.LEVEL0, (): void => {
      baseAnimExecutor.animate();
      expect(true).assertTrue();
    });

    it('exec1', Level.LEVEL0, (): void => {
      baseAnimExecutor.exec(true);
      expect(true).assertTrue();
    });

    it('exec2', Level.LEVEL0, (): void => {
      baseAnimExecutor.exec(false);
      expect(true).assertTrue();
    });

    it('preAnim', Level.LEVEL0, (): void => {
      baseAnimExecutor.preAnim();
      expect(true).assertTrue();
    });

    it('afterAnim', Level.LEVEL0, (): void => {
      baseAnimExecutor.afterAnim();
      expect(true).assertTrue();
    });
  });
}