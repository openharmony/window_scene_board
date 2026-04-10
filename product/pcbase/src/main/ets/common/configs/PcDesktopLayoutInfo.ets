/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
    DefaultDesktopLayoutInfo,
} from '@ohos/launchercommon';
export class PcDesktopLayoutInfo {
    public static PC_LAYOUT_INFO: DefaultDesktopLayoutInfo = {
        layoutDescription: {
            pageCount: 1,
            row: 9,
            column: 15,
            maxPage: 1,
            maxForm: 80
        },
        isAppCatagory: false,
        layoutInfo: []
    };
    public static FOLD_PC_LAYOUT_INFO: DefaultDesktopLayoutInfo = {
        layoutDescription: {
            pageCount: 2,
            row: 7,
            column: 12,
            maxPage: 2,
            maxForm: 80
        },
        isAppCatagory: false,
        layoutInfo: []
    };
}