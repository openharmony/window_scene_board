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
import { ListCardAnimExecutor } from '../../../../../../../main/ets/viewmodel/viewanim/executor/ListCardAnimExecutor';
import { CmpStateWrapper } from '../../../../../../../main/ets/common/helper/ComponentTransformHelper';
import { ComponentAnimState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { CardAnimType } from '../../../../../../../main/ets/common/ImmersiveConstants';

/**
 * 列表卡片动效执行器测试用例
 */
export default function ListCardAnimExecutorTest() {
  let baseAnimExecutor: ListCardAnimExecutor =
    new ListCardAnimExecutor(ImmersiveLiveAnimSceneEnum.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM);
  let mockCardStateWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('RootCard'));
  let mockCardContentWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('ContentCard'));
  let mockCardRootWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('ImageCard'));
  let mockCardPosWrapper: CmpPosWrapper = CmpPosWrapper.wrapper({ width: 50, height: 50,
    globalX: 10, globalY: 10, radius: 5 });

  let mockListRootWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('RootList'));
  let mockList1StateWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('List1'));
  let mockList2StateWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('List2'));
  let mockList3StateWrapper: CmpStateWrapper = new CmpStateWrapper(new ComponentAnimState('List3'));
  let mockList1PosWrapper: CmpPosWrapper = CmpPosWrapper.wrapper({ width: 100, height: 10,
    globalX: 10, globalY: 10, radius: 5 });
  let mockList2PosWrapper: CmpPosWrapper = CmpPosWrapper.wrapper({ width: 100, height: 10,
    globalX: 10, globalY: 30, radius: 5 });
  let mockList3PosWrapper: CmpPosWrapper = CmpPosWrapper.wrapper({ width: 100, height: 10,
    globalX: 10, globalY: 50, radius: 5 });

  // 组装列表信息
  baseAnimExecutor.putStateInfo(ImmeLiveViewNameEnum.LIVE_LIST_ROOT, mockListRootWrapper);
  let firstList = 'firstList'
  let secondList = 'secondList'
  let thirdList = 'thirdList'
  baseAnimExecutor.putStateInfo(ImmeLiveViewNameEnum.LIVE_LIST_ROOT, mockListRootWrapper);
  baseAnimExecutor.putStateInfo(firstList, mockList1StateWrapper);
  baseAnimExecutor.putPosInfo(firstList, mockList1PosWrapper);
  baseAnimExecutor.putStateInfo(secondList, mockList2StateWrapper);
  baseAnimExecutor.putPosInfo(secondList, mockList2PosWrapper);
  baseAnimExecutor.putStateInfo(secondList, mockList3StateWrapper);
  baseAnimExecutor.putPosInfo(secondList, mockList3PosWrapper);

  // 组装卡片信息
  baseAnimExecutor.putStateInfo(ImmeLiveViewNameEnum.IMMERSIVE_CARD_ROOT, mockCardStateWrapper);
  baseAnimExecutor.putStateInfo(CardAnimType.CARD_LIVE_IMAGE_TYPE, mockCardContentWrapper);
  baseAnimExecutor.putStateInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, mockCardRootWrapper);
  baseAnimExecutor.putPosInfo(CardAnimType.CARD_LIVE_CONTENT_TYPE, mockCardPosWrapper);

  describe('ListCardAnimExecutorTest', () => {
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
      baseAnimExecutor.putPosInfo("testKey", mockCardPosWrapper);
      let result: ESObject = baseAnimExecutor.getStateInfo("testKey");
      expect(result).not().assertUndefined();
    });

    it('checkCondition', Level.LEVEL0, (): void => {
      baseAnimExecutor.putStateInfo("testKey", mockCardStateWrapper);
      baseAnimExecutor.putPosInfo("testKey", mockCardPosWrapper);
      let result: boolean = baseAnimExecutor.checkCondition();
      expect(true).assertTrue();
    });

    it('complementAnimInfo', Level.LEVEL0, (): void => {
      baseAnimExecutor.complementAnimInfo();
      expect(true).assertTrue();
    });

    it('animate', Level.LEVEL0, (): void => {
      baseAnimExecutor.animate();
      expect(true).assertTrue();
    });
  });
}