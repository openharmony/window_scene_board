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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSessionRect } from '../../../../../../main/ets/TsIndex';
import { describe, it, expect, MockKit, when } from '@ohos/hypium';
import { SCBSessionRectUtils } from '../../../../../../../Index';

export default function SCBSessionRectUtilsTest() {
	describe('rectEqualsWithSessionRect_testSuite', () => {
    it('should_return_false_when_scbRect_or_rect_is_null', 0, () => {
        let rect: sceneSessionManager.SessionRect = {
          posX_: 0,
          posY_: 0,
          width_: 0,
          height_: 0
        };
        const result: ESObject = SCBSessionRectUtils.rectEqualsWithSessionRect(null, rect);
        expect(result).assertEqual(false);
    });

    it('should_return_false_when_posX_or_posY_or_width_or_height_is_not_equal', 0, () => {
        let scbRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
        let rect: sceneSessionManager.SessionRect = {
          posX_: 10,
          posY_: 20,
          width_: 30,
          height_: 40
        };
        let mocker: MockKit = new MockKit();
        let mockfunc1: Function = mocker.mockFunc(scbRect.left, scbRect.left.getPx);
        let mockfunc2: Function = mocker.mockFunc(scbRect.top, scbRect.top.getPx);
        let mockfunc3: Function = mocker.mockFunc(scbRect.width, scbRect.width.getPx);
        let mockfunc4: Function = mocker.mockFunc(scbRect.height, scbRect.height.getPx);

        when(mockfunc1)([]).afterReturn(10);
        when(mockfunc2)([]).afterReturn(20);
        when(mockfunc3)([]).afterReturn(30);
        when(mockfunc4)([]).afterReturn(40);

        const result = SCBSessionRectUtils.rectEqualsWithSessionRect(scbRect, rect);
        expect(result).assertEqual(false);

        mocker.ignoreMock(scbRect.left, scbRect.left.getPx);
        mocker.ignoreMock(scbRect.top, scbRect.top.getPx);
        mocker.ignoreMock(scbRect.width, scbRect.width.getPx);
        mocker.ignoreMock(scbRect.height, scbRect.height.getPx);
    });

    it('should_return_true_when_posX_and_posY_and_width_and_height_are_equal', 0, () => {
        let scbRect: SCBSessionRect = new SCBSessionRect(10, 20, 30, 40);
        let rect: sceneSessionManager.SessionRect = {
          posX_: 10,
          posY_: 20,
          width_: 30,
          height_: 40
        };
        let mocker: MockKit = new MockKit();
        let mockfunc1: Function = mocker.mockFunc(scbRect.left, scbRect.left.getPx);
        let mockfunc2: Function = mocker.mockFunc(scbRect.top, scbRect.top.getPx);
        let mockfunc3: Function = mocker.mockFunc(scbRect.width, scbRect.width.getPx);
        let mockfunc4: Function = mocker.mockFunc(scbRect.height, scbRect.height.getPx);

        when(mockfunc1)([]).afterReturn(10);
        when(mockfunc2)([]).afterReturn(20);
        when(mockfunc3)([]).afterReturn(30);
        when(mockfunc4)([]).afterReturn(40);

        const result = SCBSessionRectUtils.rectEqualsWithSessionRect(scbRect, rect);
        expect(result).assertEqual(true);

        mocker.ignoreMock(scbRect.left, scbRect.left.getPx);
        mocker.ignoreMock(scbRect.top, scbRect.top.getPx);
        mocker.ignoreMock(scbRect.width, scbRect.width.getPx);
        mocker.ignoreMock(scbRect.height, scbRect.height.getPx);
    });
});
}
