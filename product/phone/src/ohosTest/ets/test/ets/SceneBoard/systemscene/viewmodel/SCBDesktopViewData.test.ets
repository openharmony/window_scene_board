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

import { DesktopLayoutState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect} from '@ohos/hypium';
import { SCBDesktopViewData } from '@ohos/phonebase/src/main/ets/SceneBoard/systemscene/viewmodel/SCBDesktopViewData';

export default function SCBDesktopViewDataTest() {
    describe('launcherModel_testSuite', () => {
        beforeAll((): void => {
        })

        beforeEach((): void => {
        })

        afterAll((): void => {
        })

        afterEach((): void => {
        })

        it('atc_should_set_launcherModel_to_HOME_LAUNCHER_MODE_when_value_is_0', 0, () => {
            let scbdesktopviewdata: SCBDesktopViewData = new SCBDesktopViewData();
            scbdesktopviewdata.launcherModel = 0;
            expect(scbdesktopviewdata._launcherModel).assertEqual(DesktopLayoutState.HOME_LAUNCHER_MODE);
        });

        it('atc_should_set_launcherModel_to_HOME_LAUNCHER_MODE_when_value_is_1', 0, () => {
            let scbdesktopviewdata: SCBDesktopViewData = new SCBDesktopViewData();
            scbdesktopviewdata.launcherModel = 1;
            expect(scbdesktopviewdata._launcherModel).assertEqual(DesktopLayoutState.HOME_LAUNCHER_MODE);
        });
    })
}