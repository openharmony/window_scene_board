/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { AppIconModifier } from '../uicomponents/AppIcon';
import { AttributeUpdater } from '@ohos.arkui.modifier';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HashMap } from '@kit.ArkTS';
import { FolderAppItemInfo } from './FolderItemInfo';
import { EventConstants } from '../TsIndex';

export class BigFolderModifier extends AttributeUpdater<CommonAttribute> {
  private callback?: (instance: CommonAttribute) => void;

  public iconModifierMap: HashMap<string, AppIconModifier> = new HashMap<string, AppIconModifier>();

  initializeModifier(instance: CommonAttribute): void {
    if (this.callback) {
      this.callback(instance);
    }
  }

  iconScale(item: FolderAppItemInfo, appIconScale: number): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier?.attribute?.scale({x: appIconScale, y: appIconScale});
  }

  iconTranslate(item: FolderAppItemInfo, trans: TranslateOptions): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier.attribute?.translate(trans);
  }

  iconTransition(item: FolderAppItemInfo, transi: TransitionEffect): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier.attribute?.transition(transi);
  }

  iconGeometryTransition(item: FolderAppItemInfo, geometryTrans: string): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier.attribute?.geometryTransition(geometryTrans);
  }

  iconVisibility(item: FolderAppItemInfo, visibi: Visibility): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier.attribute?.visibility(visibi);
  }

  iconWidth(item: FolderAppItemInfo, width: number): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier.attribute?.width(width);
  }

  iconHeight(item: FolderAppItemInfo, height: number): void {
    let iconModifier: AppIconModifier = this.getModifierOfItem(item);
    iconModifier.attribute?.height(height);
  }

  private getModifierOfItem(item: FolderAppItemInfo): AppIconModifier {
    if (CheckEmptyUtils.isEmpty(item.keyName)) {
      return new AppIconModifier();
    }
    if (!this.iconModifierMap.hasKey(item.keyName)) {
      let iconModifier: AppIconModifier = new AppIconModifier();
      iconModifier.item = item;
      this.iconModifierMap.set(item.keyName, iconModifier);
      return iconModifier;
    } else {
      let iconModifier: AppIconModifier = this.iconModifierMap.get(item.keyName);
      iconModifier.item = item;
      return iconModifier;
    }
  }

  setIconModifier(item: FolderAppItemInfo, iconModifier: AppIconModifier): void {
    this.iconModifierMap.set(item.keyName, iconModifier);
  }

}