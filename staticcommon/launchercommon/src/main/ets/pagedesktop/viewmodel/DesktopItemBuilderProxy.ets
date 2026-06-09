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

import { BaseViewModel } from '../../base/BaseViewModel';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { AppIconConfig } from '../../launchericon/config/AppIconConfig';
import { DeskTopItemStyle } from '../../viewmodel/DeskTopItemStyle';

export interface DesktopItemBaseViewIf {
  tag: string;
  translateX: number;
  translateY: number;
  itemOpacity: number;
  marginValue: Margin;
  paddingValue: Padding;
  isSelect: boolean;
  isGainFocus: boolean;
  isDragStart: boolean;
  isInDrag: boolean;
  onItemSelect: Function;
  dragStart: (event: DragEvent) => void;
  dragEnd: (event: DragEvent) => void;
}

export interface AppItemViewIf extends DesktopItemBaseViewIf {
  item: AppItemInfo;
  iconSize: number;
  iconRadius: number;
  nameMaxLines: number;
  nameSize: number;
  nameWidth: number;
  desktopStyle: DeskTopItemStyle;
  appIconConfig: AppIconConfig;
  isDesktopItem: boolean;
  isIconSizeFixed: boolean;
  getIndexInSwiper: Function;
}

export interface FileFolderViewIf extends DesktopItemBaseViewIf {
  item: GridLayoutItemInfo;
  iconSize: number;
  maxLines: number;
  verticalMargin: number;
  fileFolderNameSize: number;
  fileFolderItemWidth: number;
  fileFolderItemHeight: number;
  isShowShadow: boolean;
  isCut: boolean;
  isDragPaste: boolean;
  getContainerViewModel: () => BaseViewModel;
}

@Builder function emptyItemViewBuilder($$: DesktopItemBaseViewIf) {
}

export class DesktopItemBuilderProxy {
  private static instance: DesktopItemBuilderProxy;
  private builderMap: Map<string, WrappedBuilder<DesktopItemBaseViewIf[]>> = new Map();

  private constructor() {
  }

  public static getInstance(): DesktopItemBuilderProxy {
    if (!DesktopItemBuilderProxy.instance) {
      DesktopItemBuilderProxy.instance = new DesktopItemBuilderProxy();
    }
    return DesktopItemBuilderProxy.instance;
  }

  public setDesktopItemBuilder<T extends DesktopItemBaseViewIf>(itemName: string, builder: WrappedBuilder<T[]>): void {
    this.builderMap.set(itemName, builder as WrappedBuilder<DesktopItemBaseViewIf[]>);
  }

  public getDesktopItemBuilder(itemName: string): WrappedBuilder<DesktopItemBaseViewIf[]> {
    return this.builderMap.get(itemName) ?? wrapBuilder(emptyItemViewBuilder);
  }
}