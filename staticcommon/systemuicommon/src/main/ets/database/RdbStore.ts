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

import { relationalStore } from '@kit.ArkData';
import ctx from '@ohos.app.ability.common';
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SystemUICommonUtil } from '../utils/SystemUICommonUtil';
import { TaskItem, TaskQueue } from '../utils/TaskQueue';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';

const log = LogHelper.getLogHelper(LogDomain.NC, 'RdbStore');
const AREA_MODE_EL1 = 0;
const MAX_RETRY_TIMES = 3;
const QUERY_TIMEOUT = 120000; //和消息队列保持一样，超时就丢弃，防止rdb查询一直卡住

export class RdbStore {
  private storePromise?: CustomPromise<relationalStore.RdbStore>;
  private store?: relationalStore.RdbStore;
  /**
   * 使用store的引用计数，当减为0时需要关闭数据库
   */
  private storeUsingCount = 0;
  private context?: ctx.Context;
  /**
   * 数据库查询的任务队列，由于RDB开了5个常驻连接，因此这里最多支持5个并发查询，多了会产生多余的连接导致无法关闭
   */
  private queryQueue: TaskQueue = new TaskQueue('RdbStore', 5);

  /**
   * 构造RDB数据库
   * @param storeConfig 数据库配置
   */
  constructor(private storeConfig: relationalStore.StoreConfig) { }

  /**
   * 初始化数据库
   * @param context
   */
  public async initStore(context: ctx.Context): Promise<void> {
    this.context = context;
  }

  /**
   * 通过谓词查询数据
   */
  public async query(rp: relationalStore.RdbPredicates, columns?: Array<string>):
    Promise<relationalStore.ResultSet> {
    const task = new TaskItem('query', async (): Promise<relationalStore.ResultSet> => {
      try {
        const store = await this.getStore();
        return await store.query(rp, columns);
      } finally {
        this.closeStore();
      }
    });
    task.timeout = QUERY_TIMEOUT;
    this.queryQueue.add(task);
    return task.resultPromise;
  }

  /**
   * 通过SQL语句查询数据
   */
  public async querySql(sql: string, bindArgs?: Array<relationalStore.ValueType>):
    Promise<relationalStore.ResultSet> {
    const task = new TaskItem('querySql', async (): Promise<relationalStore.ResultSet> => {
      try {
        const store = await this.getStore();
        return await store.querySql(sql, bindArgs);
      } finally {
        this.closeStore();
      }
    });
    task.timeout = QUERY_TIMEOUT;
    this.queryQueue.add(task);
    return task.resultPromise;
  }

  /**
   * 执行sql语句
   */
  public async execute(sql: string, args?: relationalStore.ValueType[]): Promise<relationalStore.ValueType> {
    try {
      const store = await this.getStore();
      return store.execute(sql, args);
    } finally {
      this.closeStore();
    }
  }

  /**
   * 执行sql语句
   */
  public async executeSql(sql: string, bindArgs?: Array<relationalStore.ValueType>): Promise<void> {
    try {
      const store = await this.getStore();
      return await store.executeSql(sql, bindArgs);
    } finally {
      this.closeStore();
    }
  }

  /**
   * 插入数据
   */
  public async insert(table: string, values: relationalStore.ValuesBucket): Promise<number> {
    try {
      const store = await this.getStore();
      return await store.insert(table, values);
    } finally {
      this.closeStore();
    }
  }

  /**
   * 更新数据
   */
  public async update(values: relationalStore.ValuesBucket, rp: relationalStore.RdbPredicates): Promise<number> {
    try {
      const store = await this.getStore();
      return await store.update(values, rp);
    } finally {
      this.closeStore();
    }
  }

  /**
   * 删除数据
   */
  public async delete(rp: relationalStore.RdbPredicates): Promise<number> {
    try {
      const store = await this.getStore();
      return await store.delete(rp);
    } finally {
      this.closeStore();
    }
  }

  /**
   * 开启事物
   * @returns
   */
  public async beginTransaction(): Promise<void> {
    const store = await this.getStore();
    // 开启事务时，不释放store的引用
    store.beginTransaction();
  }

  /**
   * 提交事物
   * @returns
   */
  public async commit(): Promise<void> {
    try {
      const store = await this.getStore();
      store.commit();
    } finally {
      this.closeStore(true);
    }
  }

  /**
   * 开始批量操作, 该接口需要与endBatch成对调用
   * 该接口将获取数据库连接, 后续的相关操作都会共用同一连接
   * @returns
   */
  public async beginBatch(): Promise<void> {
    await this.getStore();
  }

  /**
   * 结束批量操作, 该接口需要与beginBatch成对调用
   * 该接口将释放数据库连接, 注意与beginBatch成对
   * @returns
   */
  public async endBatch(): Promise<void> {
    await this.closeStore();
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    this.storeUsingCount++;
    if (this.storePromise) {
      return this.storePromise;
    }
    this.storePromise = new CustomPromise();
    let i = 0;
    while (i++ < MAX_RETRY_TIMES) {
      log.showInfo(`Get rdb store in ${i} times begin`);
      if (!this.context) {
        await SystemUICommonUtil.sleep(Math.pow(2, i) * 1000);
        continue;
      }
      try {
        const oldArea = this.context.area;
        this.context.area = AREA_MODE_EL1;
        const getStorePromise = relationalStore.getRdbStore(this.context, this.storeConfig);
        this.context.area = oldArea;
        log.showInfo('await get store promise start');
        this.store = await getStorePromise;
        log.showInfo('await get store promise end');
        this.storePromise.resolve(this.store);
        log.showInfo(`Init rdb store for ${this.storeConfig.name} success`);
        break;
      } catch (e) {
        LogWithHa.error(log, `Get rdb store in ${i} times error: ${e?.message}`, e);
        await SystemUICommonUtil.sleep(Math.pow(2, i) * 1000);
      }
    }
    if (!this.store) {
      this.storePromise.reject(new Error(`Cannot get store for ${this.storeConfig.name}`));
    }
    return this.store;
  }

  private async closeStore(commit: boolean = false): Promise<void> {
    try {
      // 若为提交事务，则需要释放beginTransaction的引用
      this.storeUsingCount -= (commit ? 2 : 1);
      if (!this.storeUsingCount && this.store) {
        const closingStore = this.store;
        this.storePromise = undefined;
        this.store = undefined;
        await closingStore.close();
        log.showInfo('Close store success');
      }
    } catch (e) {
      log.error('Close store error:', e);
    }
  }
}