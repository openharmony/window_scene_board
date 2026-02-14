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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when} from '@ohos/hypium';
import { SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SingleRowRecentLayoutCal } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/SingleRowRecentLayoutCal';

export default function SingleRowRecentLayoutCalTest() {
  describe('SingleRowRecentLayoutCalTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('test_Recent_SingleRowLayout_GetEndIndex', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEndIndex(0)).assertInstanceOf('Number');
    })

    it('test_Recent_SingleRowLayout_GetRecentLayoutWidth_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getRecentLayoutWidth(0, 0)).assertInstanceOf('Number');
    })

    it('getEnterRecentTargetOffsetX_test_less0', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEnterRecentTargetOffsetX(-1, 0, false)).assertEqual(0);
    })

    it('getEnterRecentTargetOffsetX_test_equal0', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEnterRecentTargetOffsetX(0, 0, false)).assertEqual(0);
    })

    it('getEnterRecentTargetOffsetX_test_isFromApp_true', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEnterRecentTargetOffsetX(1, 1, true)).assertEqual(0);
    })

    it('getEnterRecentTargetOffsetX_test_isFromApp_false_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEnterRecentTargetOffsetX(1, 1, false)).assertLess(152);
    })

    it('getEnterRecentTargetOffsetX_test_isFromApp_false_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEnterRecentTargetOffsetX(1, 0, false)).assertLess(152);
    })

    it('getEnterRecentTargetOffsetX_test_isFromApp_false_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let singleRowRecentLayoutCal: SingleRowRecentLayoutCal = new SingleRowRecentLayoutCal(SCBScenePanelManager.getInstance());
      expect(singleRowRecentLayoutCal.getEnterRecentTargetOffsetX(1, 0, true)).assertLess(152);
    })
  })
}