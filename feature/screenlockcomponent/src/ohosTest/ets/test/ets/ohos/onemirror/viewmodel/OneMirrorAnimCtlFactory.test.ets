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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import OneMirrorAnimCtlFactory, {
  OneMirrorAnimCtlType
} from '../../../../../../../main/ets/onemirror/viewmodel/OneMirrorAnimCtlFactory';
import { AodProxyMock } from '../../model/AodProxyMock';

/**
 * 沉浸式锁屏测试用例
 */
export default function OneMirrorAnimCtlFactoryTest() {
  describe('OneMirrorAnimCtlFactoryTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let aIAodProxy: AodProxyMock = new AodProxyMock();
    let animFactory: OneMirrorAnimCtlFactory = new OneMirrorAnimCtlFactory(aIAodProxy);

    it('OneMirrorAnimCtlFactory_test_getMirrorControllerByType', Level.LEVEL0, (): void => {
      animFactory.getMirrorControllerByType(OneMirrorAnimCtlType.ONE_MIRROR_FULL);
      animFactory.getMirrorControllerByType(OneMirrorAnimCtlType.ONE_MIRROR_PART_EMOJI);
    });

    it('OneMirrorAnimCtlFactory_test_getMirrorController', Level.LEVEL0, (): void => {
      animFactory.getMirrorController();

      aIAodProxy.mockIsPartEmoji = true;
      animFactory.getMirrorController();

      aIAodProxy.mockIsPartEmoji = false;
      aIAodProxy.mockIsPartScreenAOD = true;
      animFactory.getMirrorController();
    });
  });
}