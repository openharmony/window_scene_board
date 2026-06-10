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

import hilog from '@ohos.hilog';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import FreezingTipUtil from '@ohos/screenlockcomponent/src/main/ets/common/FreezingTipUtil';

export default function FreezingTipUtilTest() {

    describe('FreezingTipUtil', (): void => {
        // Defines a test suite. Two parameters are supported: test suite name and test suite function.
        beforeAll((): void => {
            // Presets an action, which is performed only once before all test cases of the test suite start.
            // This API supports only one parameter: preset action function.
        })
        beforeEach((): void => {
            // Presets an action, which is performed before each unit test case starts.
            // The number of execution times is the same as the number of test cases defined by **it**.
            // This API supports only one parameter: preset action function.
        })
        afterEach((): void => {
            // Presets a clear action, which is performed after each unit test case ends.
            // The number of execution times is the same as the number of test cases defined by **it**.
            // This API supports only one parameter: clear action function.
        })
        afterAll((): void => {
            // Presets a clear action, which is performed after all test cases of the test suite end.
            // This API supports only one parameter: clear action function.
        })
        it('test_getFreezingTimeStr_success', 0, async (): Promise<void> => {
            hilog.info(0x0000, 'testTag', '%{public}s', 'it begin');
            try {
                expect(await FreezingTipUtil.getFreezingTimeStr(0)).assertEqual('');
                expect(await FreezingTipUtil.getFreezingTimeStr(1)).assertEqual('1 秒');
                expect(await FreezingTipUtil.getFreezingTimeStr(1000)).assertEqual('1 秒');
                expect(await FreezingTipUtil.getFreezingTimeStr(2000)).assertEqual('2 秒');
                expect(await FreezingTipUtil.getFreezingTimeStr(59999)).assertEqual('60 秒');
                expect(await FreezingTipUtil.getFreezingTimeStr(60000)).assertEqual('1 分钟');
                expect(await FreezingTipUtil.getFreezingTimeStr(60001)).assertEqual('1 分钟 1 秒');
            } catch (e) {
                expect(false).assertFail();
            }
        })

        it('test_getFreezingTimeStr_one', 0, async (): Promise<void> => {
            await FreezingTipUtil.getFreezingTimeStr(600000);
            expect(true).assertTrue();
        })

        it('test_getFreezingTimeStr_two', 0, async (): Promise<void> => {
            await FreezingTipUtil.getFreezingTimeStr(600001);
            expect(true).assertTrue();
        })
    })
}