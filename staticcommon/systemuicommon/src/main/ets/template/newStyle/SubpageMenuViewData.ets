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

/**
 * 二级页信息
 */
export class SubpageElementInfo {
  public titleIcon: ResourceStr | PixelMap;
  public titleText: ResourceStr = ''
  public domId: string = '';
  public menuList: MenuEntry[] = [];
  public onMoreSettingClick: () => void = () => {
  };
  public onMenuItemClick: (item: MenuEntry) => void = (item: MenuEntry) => {
  };

  constructor(titleIcon: ResourceStr | PixelMap, titleText: ResourceStr, domId: string) {
    this.titleIcon = titleIcon;
    this.titleText = titleText;
    this.domId = domId;
  }
}

/**
 * 二级页列表元素
 */
@Observed
export class MenuEntry {
  public icon: ResourceStr | PixelMap;
  public title: ResourceStr | string = '';
  public itemKey: string = '';
  public subTitle?: string;
  public isSelected: boolean = false;

  constructor(icon: ResourceStr | PixelMap, title: ResourceStr, itemKey: string, subTitle?: string) {
    this.icon = icon;
    this.title = title;
    this.itemKey = itemKey;
    this.subTitle = subTitle;
  }
}