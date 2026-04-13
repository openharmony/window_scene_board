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
import { HideBannerContentType } from '../constants/HideBannerContentType';
import { Column, Table } from '../database/TableDecorator';
import { TableEntity } from '../database/TableEntity';

/**
 * 应用通知配置表信息
 */
@Table({
  name: 'NotificationConfig'
})
export class NotificationConfigEntity extends TableEntity {
  /**
   * 应用包名
   */
  @Column({ name: 'bundle', type: 'string' })
  public bundle: string;

  /**
   * 应用用户ID
   */
  @Column({ name: 'userId', type: 'number' })
  public userId: number;

  /**
   * 应用uid
   */
  @Column({ name: 'uid', type: 'number' })
  public uid: number;

  /**
   * 应用分身索引
   */
  @Column({ name: 'appIndex', type: 'number' })
  public appIndex: number = 0;

  /**
   * 包类型（应用or元服务）
   */
  @Column({ name: 'bundleType', type: 'number' })
  public bundleType: number;

  /**
   * 应用版本
   */
  @Column({ name: 'versionName', type: 'string' })
  public versionName: string;

  /**
   * 当前语言
   */
  @Column({ name: 'language', type: 'string' })
  public language: string;

  /**
   * 应用名称
   */
  @Column({ name: 'label', type: 'string' })
  public label: string;

  /**
   * 应用图标
   */
  @Column({ name: 'icon', type: 'string' })
  public icon: string;

  /**
   * 是否为系统应用
   */
  @Column({ name: 'systemApp', type: 'boolean' })
  public systemApp: boolean = false;

  /**
   * 是否隐藏通知设置入口
   */
  @Column({ name: 'settingIgnore', type: 'boolean' })
  public settingIgnore: boolean = false;

  /**
   * 是否置顶
   */
  @Column({ name: 'pinTop', type: 'boolean' })
  public pinTop: boolean = false;

  /**
   * 是否隐藏横幅通知内容
   */
  @Column({ name: 'hideBannerContent', type: 'number' })
  public hideBannerContent: number = HideBannerContentType.FOLLOW_SYSTEM;

  /**
   * 排序标签
   */
  @Column({ name: 'sortTag', type: 'string' })
  public sortTag: string = '';

  /**
   * 相等
   *
   * @param other 比较对象
   */
  equals(other: NotificationConfigEntity): boolean {
    if (other == null) {
      return false;
    }

    const tableColumns = NotificationConfigEntity.getTableColumns();
    // 依次比较所有字段
    for (let column of tableColumns) {
      if (this[column.name] !== other[column.name]) {
        return false;
      }
    }
    return true;
  }
}

/**
 * 应用通知置顶设置参数数据结构
 */
export class PinTopConfigCommand {
  uid: number;
  enable: boolean;
}