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

import { BadgeAnimationType, CustomBadgeModifier } from '../../uicomponents/CustomBadge';

@Observed
export class AppIconBadgeVm {
  @Track public enable: boolean = true;
  @Track public badgeNumber: number = 0;
  @Track public visible: boolean = true;
  @Track public animate: BadgeAnimationType = BadgeAnimationType.DEFAULT;
  @Track public isUpdateSuperposeBadge: boolean = true;
  @Track public bindFolderId: string = '';
  @Track public isSuperposeApp: boolean = false;
  @Track public isBadgeMinimize: boolean = false;
  @Track public isCustom: boolean = false;
  @Track public modifier: CustomBadgeModifier = new CustomBadgeModifier;
  @Track public ratio: number = 1;
}