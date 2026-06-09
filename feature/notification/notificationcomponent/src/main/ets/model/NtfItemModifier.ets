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
import { NtfItemSwipeController } from '../controller/NtfItemSwipeController';
import { NotificationEntry } from './NotificationEntry';
import { NtfCloseVM } from '../vm/NtfCloseVM';
import { NotificationAnimationParas } from '../common/NotificationAnimationParas';

export class NtfSingleItemModifier implements AttributeModifier<ColumnAttribute> {
  private swipeController?: NtfItemSwipeController;
  private ntfEntry?: NotificationEntry;
  private closeVM?: NtfCloseVM
  private itemContentArea?: Area;

  constructor(swipeController: NtfItemSwipeController, closeVM?: NtfCloseVM) {
    this.swipeController = swipeController;
    this.closeVM = closeVM;
  }

  public setEntry(ntfEntry?: NotificationEntry): void {
    this.ntfEntry = ntfEntry;
  }

  private onItemHoverChange(isHover: boolean): void {
    if (isHover) {
      this.closeVM?.setItemHover(this.ntfEntry!);
      this.closeVM?.updatePosition(this.ntfEntry!, this.itemContentArea!);
    } else {
      this.closeVM?.cancelItemHover(this.ntfEntry!);
    }
  }

  applyNormalAttribute(instance: ColumnAttribute): void {
    if (this.closeVM) {
      instance.onAreaChange((oldValue, newValue) => {
        this.swipeController?.setItemWidth(newValue.width as number);
        this.itemContentArea = newValue;
        this.closeVM?.updatePosition(this.ntfEntry!, this.itemContentArea!);
      })
        .onHover((isHover: boolean) => {
          this.onItemHoverChange(isHover);
        })
    } else {
      instance.onSizeChange(this.closeVM ? undefined : (oldValue, newValue) => {
        this.swipeController?.setItemWidth(newValue.width as number);
      })
    }
  }
}

export class NtfGroupItemModifier implements AttributeModifier<CommonAttribute> {
  private ntfEntry?: NotificationEntry;
  private closeVM?: NtfCloseVM;
  private itemContentArea?: Area;

  constructor(closeVM?: NtfCloseVM) {
    this.closeVM = closeVM;
  }

  public setEntry(ntfEntry?: NotificationEntry): void {
    this.ntfEntry = ntfEntry;
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    if (this.closeVM) {
      instance
        .onAreaChange((oldArea, newArea) => {
          this.closeVM?.updatePosition(this.ntfEntry!, newArea!);
          this.itemContentArea = newArea;
        })
        .onHover((isHover: boolean) => {
          if (!isHover) {
            this.closeVM?.cancelItemHover(this.ntfEntry!);
          } else {
            this.closeVM?.setItemHover(this.ntfEntry!);
            this.closeVM?.updatePosition(this.ntfEntry!, this.itemContentArea!);
          }
        })
    }
  }
}

export class GroupItemAreaModifier implements AttributeModifier<CommonAttribute> {
  private ntfAnimationParas?: NotificationAnimationParas;

  constructor(ntfAnimationParas?: NotificationAnimationParas) {
    this.ntfAnimationParas = ntfAnimationParas;
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    if (this.ntfAnimationParas?.isBottomItem) {
      instance
        .onAreaChange((oldArea, newArea) => {
          this.ntfAnimationParas?.updateClipArea(newArea);
        })
    }
  }
}

export class SingleItemAreaModifier implements AttributeModifier<CommonAttribute> {
  private ntfAnimationParas?: NotificationAnimationParas;
  private isInGroup?: boolean;

  constructor(ntfAnimationParas?: NotificationAnimationParas, isInGroup: boolean = false) {
    this.ntfAnimationParas = ntfAnimationParas;
    this.isInGroup = isInGroup;
  }

  applyNormalAttribute(instance: CommonAttribute): void {
    if (this.ntfAnimationParas?.isBottomItem && !this.isInGroup) {
      instance
        .onAreaChange((oldArea, newArea) => {
          this.ntfAnimationParas?.updateClipArea(newArea);
        })
    }
  }
}