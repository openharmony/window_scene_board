/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  SqueezeEngineType
} from '../../../../../../../../../main/ets/service/compomentdrag/common/type/SqueezeTypes';
import {
  EngineFactory
} from '../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/EngineFactory';
import {
  BackwardSingleItemSqueezeEngine
} from '../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/singleitem/BackwardSingleItemSqueezeEngine';
import {
  SqueezeEngineChain
} from '../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/SqueezeEngineChain';

/**
 * SqueezeEngineChain DT测试套
 */
export function SqueezeEngineChainTest() {
  describe('SqueezeEngineChainTest', (): void => {

    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_SqueezeEngineChain_register', Level.LEVEL0, (): void => {
      let engineType = SqueezeEngineType.BACKWARD_SINGLE_ITEM_SQUEEZE;
      let engine = new BackwardSingleItemSqueezeEngine();
      EngineFactory.register(engineType, engine);
      EngineFactory.register(engineType, engine);
      let engine1 = EngineFactory.getEngine(engineType);
      expect(engine1).assertEqual(engine);
    })

    it('test_SqueezeEngineChain_getSqueezeResult', Level.LEVEL0, (): void => {
      let engineType1 = SqueezeEngineType.BACKWARD_SINGLE_ITEM_SQUEEZE;
      let engine = new BackwardSingleItemSqueezeEngine();
      EngineFactory.register(engineType1, engine);
      let chain = new SqueezeEngineChain(true);
      chain.addSqueezeEngineType(engineType1);
      let engineType2 = null;
      chain.addSqueezeEngineType(engineType2);
      let itemList = chain.getSqueezeResult(0, 0);
      expect(itemList.size).assertEqual(0);
    })
  })
}