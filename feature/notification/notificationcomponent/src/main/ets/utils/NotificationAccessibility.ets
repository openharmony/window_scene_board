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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationConstants } from '../common/NotificationConstants';
import { NotificationEntry } from '../model/NotificationEntry';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'NtfListContentAccessibilitys');

class CustomAccessibilityNtfEntry extends NotificationEntry {
  private groupTypeKey: string;

  constructor(groupTypeKey: string) {
    super(undefined);
    this.groupTypeKey = groupTypeKey;
  }

  getGroupTypeKey(): string {
    return this.groupTypeKey;
  }
}

export class ListContentAccessibility {
  private mainShowingNtfs: NotificationEntry[];
  private extraShowingNtfs: NotificationEntry[];
  private isExtraNtfsCollapsed: boolean;

  constructor(mainNtfs: NotificationEntry[], extraNtfs: NotificationEntry[], isExtraNtfsCollapsed: boolean) {
    this.isExtraNtfsCollapsed = isExtraNtfsCollapsed;
    this.mainShowingNtfs = mainNtfs;
    this.extraShowingNtfs = this.getShowingExtraItemNtfs(extraNtfs);
  }

  private getShowingExtraItemNtfs(extraNtfs: NotificationEntry[]): NotificationEntry[] {
    if (extraNtfs.length === 0) {
      return [];
    }

    if (this.isExtraNtfsCollapsed) {
      return [new CustomAccessibilityNtfEntry(NotificationConstants.NTF_CENTER_EXTRA_BRIEF_COMP_ID)];
    } else {
      return extraNtfs;
    }
  }

  public getNextFocusCompIdWhenRemoveListItem(removeListItemCompId: string): string | undefined {
    const nextFocusEntry = this.getNextFocusEntry(removeListItemCompId);
    if (nextFocusEntry) {
      return this.getEntryAccessibilityId(nextFocusEntry);
    }
    return undefined;
  }

  private getNextFocusEntry(removeListItemCompId: string): NotificationEntry | undefined {
    const allEntries = this.getAllShowingEntries();
    if (allEntries.length === 0) {
      log.showWarn('CalcNextAccByRemoveCompId for empty ids');
      return undefined;
    }

    // 删除最后一个通知时不需要手动聚焦
    if (allEntries.length === 1 && allEntries[0].getGroupTypeKey() === removeListItemCompId) {
      return undefined;
    }

    // 只存在一个更多通知，且删除该通知时，返回最后一个主通知
    if (this.extraShowingNtfs.length === 1 &&
    this.extraShowingNtfs.some(it => it.getGroupTypeKey() === removeListItemCompId)) {
      return this.mainShowingNtfs.length > 0 ? this.mainShowingNtfs[this.mainShowingNtfs.length - 1] : undefined;
    }

    const removeIdx = allEntries.findIndex(it => it.getGroupTypeKey() === removeListItemCompId);
    if (removeIdx < 0) {
      log.showWarn('CalcNextAccByRemoveCompId not find itemId: %{public}s', removeListItemCompId);
      return undefined;
    }

    // 删除最后一个时焦点向前移动
    if (removeIdx === allEntries.length - 1 && allEntries.length > 2) {
      return allEntries[allEntries.length - 2];
    }

    // 其他场景删除时焦点向下一个卡片移动
    return allEntries[removeIdx + 1];
  }

  private getAllShowingEntries(): NotificationEntry[] {
    const result: NotificationEntry[] = [...this.mainShowingNtfs];
    if (this.extraShowingNtfs.length > 0) {
      result.push(new CustomAccessibilityNtfEntry(NotificationConstants.NTF_CENTER_EXTRA_TITLE_COMP_ID));
      result.push(...this.extraShowingNtfs);
    }
    return result;
  }

  private getEntryAccessibilityId(entry: NotificationEntry): string {
    log.showInfo('getEntryAccessibility %{public}s %{public}s %{public}s %{public}s %{public}d',
      entry.isGroup, entry.isItemExpanded, entry.hashCode, entry.getGroupTypeKey(), entry.childrenEntry?.length);
    const isGroup = entry.isGroup && entry.childrenEntry && entry.childrenEntry.length > 1;
    if (entry instanceof CustomAccessibilityNtfEntry) {
      return entry.getGroupTypeKey();
    } else if (!isGroup) {
      return `NotificationSingleItem_${entry.hashCode ?? entry.childrenEntry?.[0]?.hashCode}`;
    } else if (entry.isItemExpanded) {
      return `NotificationHeader_${entry.getGroupTypeKey()}`
    } else {
      return NotificationConstants.getGroupBriefItemCompId(entry.getGroupTypeKey());
    }
  }
}

export class GroupAccessibility {
  private groupItemId: string;

  private childHashCodes: string[];

  private ntfListContentAccessibilityBuilder: () => ListContentAccessibility;

  constructor(groupEntry: NotificationEntry, ntfListContentAccessibilityBuilder: () => ListContentAccessibility) {
    this.ntfListContentAccessibilityBuilder = ntfListContentAccessibilityBuilder;
    this.groupItemId = groupEntry.getGroupTypeKey();
    this.childHashCodes = groupEntry.childrenEntry?.map(it => it.hashCode ?? '')!;
  }

  public getNextFocusCompIdWhenRemoveSubNtf(removeSubNtfHashCode: string): string | undefined {
    if (this.childHashCodes.length === 0) {
      log.showWarn('GetNextFocusCompIdWhenRemoveSubNtf for %{public}s without sub hashcode', removeSubNtfHashCode);
      return undefined;
    }

    // 删除组通知中最后一个子通知时，按组通知删除逻辑执行
    if (this.childHashCodes.length === 1) {
      if (this.childHashCodes[0] === removeSubNtfHashCode) {
        return this.ntfListContentAccessibilityBuilder().getNextFocusCompIdWhenRemoveListItem(this.groupItemId);
      } else {
        log.showWarn('GetNextFocusCompIdWhenRemoveSubNtf for %{public}s len 1 but this', removeSubNtfHashCode);
        return undefined;
      }
    }

    const removeIdx = this.childHashCodes.findIndex(it => it === removeSubNtfHashCode);
    if (removeIdx < 0) {
      log.showWarn('GetNextFocusCompIdWhenRemoveSubNtf for %{public}s not in children', removeSubNtfHashCode);
      return undefined;
    }

    let nextAccHashCode: string;
    if (removeIdx === this.childHashCodes.length - 1) {
      nextAccHashCode = this.childHashCodes[this.childHashCodes.length - 2];
    } else {
      nextAccHashCode = this.childHashCodes[removeIdx + 1];
    }

    return `${NotificationConstants.NTF_CENTER_GROUP_SUB_COMP_ID_PREFIX}_${nextAccHashCode}`;
  }
}