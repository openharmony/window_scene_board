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
import { describe, it, expect, beforeAll, beforeEach, afterAll, afterEach } from '@ohos/hypium'
import { HighFrequencyCallStatistics, Statistics } from '../../../../../../main/ets/db/dfx/HighFrequencyCallStatistics'

export default function HighFrequencyCallStatisticsTest() {
  beforeAll((): void => {});
  beforeEach((): void => {})
  afterAll((): void => {})
  afterEach((): void => {})
  describe('HighFrequencyCallStatisticsTest', () => {
    /*
     * 测试场景:
     *   创建0长度的统计模块
     * 结果说明：
     *   兜底生成1长度的统计模块
     */
    it('test_create_null_scene', 0, () => {
      let stats = new HighFrequencyCallStatistics(0);
      expect(stats.getScenes().length).assertEqual(1);
    })

    /*
     * 测试场景:
     *   创建正常的统计模块
     *   1. 传入undefined的场景名称
     *   2. 传入null的场景名称
     *   3. 传入空字符串的场景名称
     * 结果说明：
     *   非空的场景名称都不会作为有效数据统计
     */
    it('test_null_scene', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      /* 传入各种空值，被拦截 */
      stats.record(undefined, 1000);
      stats.record(null, 1100);
      stats.record('', 1200);
      const count = stats.getScenes()[0].getTriggerCount(1000, 1200);
      expect(count).assertEqual(0);
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 传入正常的统计场景名称和时间
     * 结果说明：
     *   统计并记录成功，该场景记录条数1
     */
    it('test_single_scene_basic1', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      stats.record('test1', 1000);
      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(1);
      expect(result[0]).assertEqual(1000);
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 传入正常的统计场景名称和时间
     *   2. 传入正常的统计场景名称和时间
     * 结果说明：
     *   统计并记录成功，该场景记录条数2
     */
    it('test_single_scene_basic2', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      stats.record('test1', 1000);
      stats.record('test1', 1100);
      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(2);
      expect(result[0]).assertEqual(1000);
      expect(result[1]).assertEqual(1100);
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 循环传入慢速正常的统计场景名称和时间直至统计条数满
     * 结果说明：
     *   统计并记录成功，该场景记录条数满
     */
    it('test_single_scene_full', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      const times = stats.getScenes()[0].getTriggerTimes().length;
      for (let i = 0; i < times; i++) {
        /* 注意，这里不会触发warn */
        stats.record('test1', 100000 + i * 10000);
      }
      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(times);
      for (let i = 0; i < times; i++) {
        expect(result[i]).assertEqual(100000 + i * 10000);
      }
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 循环传入慢速正常的统计场景名称和时间直至统计条数满
     *   2. 再次传入1次慢速正常的统计场景名称和时间直至统计条数满
     * 结果说明：
     *   统计并记录成功，该场景记录条数满，第一个数据会被第二部的值覆盖，其他值不变
     */
    it('test_single_scene_overflow1', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      const times = stats.getScenes()[0].getTriggerTimes().length;
      for (let i = 0; i < times; i++) {
        stats.record('test1', 100000 + i * 10000);
      }
      /* 会刷新第一个数据 */
      stats.record('test1', 500000);

      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(times);
      expect(result[0]).assertEqual(500000);
      for (let i = 1; i < times; i++) {
        expect(result[i]).assertEqual(100000 + i * 10000);
      }
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 循环传入慢速正常的统计场景名称和时间直至统计条数满
     *   2. 再次循环传入慢速正常的统计场景名称和时间直至统计条数满
     * 结果说明：
     *   统计并记录成功，该场景记录条数满，值均为第二轮的数据
     */
    it('test_single_scene_overflow2', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      const times = stats.getScenes()[0].getTriggerTimes().length;
      for (let i = 0; i < times; i++) {
        stats.record('test1', 100000 + i * 10000);
      }
      /* 会刷新全部数据 */
      for (let i = 0; i < times; i++) {
        stats.record('test1', 500000 + i * 10000);
      }

      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(times);
      for (let i = 0; i < times; i++) {
        expect(result[i]).assertEqual(500000 + i * 10000);
      }
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 循环传入快速正常的统计场景名称和时间直至触发告警（上限+1次）
     * 结果说明：
     *   统计并记录成功，告警后记录清零
     */
    it('test_single_scene_warn', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      for (let i = 0; i < Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME + 1; i++) {
        stats.record('test1', 1000 + i);
      }
      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(0);
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 循环传入快速正常的统计场景名称和时间直至触发告警（上限+1次）
     *   2. 再次传入正常的统计场景名称和时间
     * 结果说明：
     *   统计并记录成功，告警清零后再记录了一条记录
     */
    it('test_single_scene_warn2', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      /* 构造触发warn后，再记录一次数据，这时候从0开始 */
      for (let i = 0; i < Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME + 2; i++) {
        stats.record('test1', 1000 + i);
      }
      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result.length).assertEqual(1);
      expect(result[0]).assertEqual(1000 + Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME + 1);
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 传入正常的统计场景名称和时间
     *   2. 延迟一段时间再循环传入快速正常的统计场景名称和时间直至触发告警（上限+1次）
     * 结果说明：
     *   统计并记录成功，最后一次记录导致告警触发清零记录
     */
    it('test_single_scene_warn3', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      /* 构造慢速，再快速触发warn场景，这时候慢速数据不应该被统计进去 */
      stats.record('test1', 100000);
      for (let i = 0; i < Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME + 1; i++) {
        stats.record('test1', 200000 + i);
        const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
        if (i === Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME) {
          expect(result.length).assertEqual(0);
        } else {
          expect(result.length).assertLarger(0);
        }
      }
    })

    /*
     * 测试场景:
     *   创建正常单条统计模块
     *   1. 传入正常的统计场景名称和时间
     *   2. 传入新的正常的场景名称和时间
     * 结果说明：
     *   统计并记录成功，记录被新的场景抢占
     */
    it('test_single_scene_recycle', 0, () => {
      let stats = new HighFrequencyCallStatistics(1);
      stats.record('test1', 1000);
      stats.record('test1', 1100);
      stats.record('test2', 1200);
      const result = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      expect(stats.getScenes()[0].getScene()).assertEqual('test2');
      expect(result.length).assertEqual(1);
      expect(result[0]).assertEqual(1200);
    })

    /*
     * 测试场景:
     *   创建正常双条统计模块
     *   1. 传入正常的统计场景1名称和时间
     *   2. 传入正常的统计场景2名称和时间
     * 结果说明：
     *   统计并记录成功
     */
    it('test_dual_scene_basic1', 0, () => {
      let stats = new HighFrequencyCallStatistics(2);
      stats.record('test1', 1000);
      stats.record('test2', 1100);
      const result1 = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      const result2 = stats.getScenes()[1].getTriggerTimes().filter((time) => { return time > 0 });
      expect(stats.getScenes()[0].getScene()).assertEqual('test1');
      expect(stats.getScenes()[1].getScene()).assertEqual('test2');
      expect(result1.length).assertEqual(1);
      expect(result1[0]).assertEqual(1000);
      expect(result2.length).assertEqual(1);
      expect(result2[0]).assertEqual(1100);
    })

    /*
     * 测试场景:
     *   创建正常双条统计模块
     *   1. 循环传入慢速正常的统计场景1名称和时间直至统计条数满
     * 结果说明：
     *   统计并记录成功，第二个统计记录没有被场景1占用
     */
    it('test_dual_scene_single_overflow_not_effect_others1', 0, () => {
      let stats = new HighFrequencyCallStatistics(2);

      /* 慢速填充 */
      const times = stats.getScenes()[0].getTriggerTimes().length;
      for (let i = 0; i < times; i++) {
        stats.record('test1', 100000 + i * 10000);
      }
      stats.record('test1', 500000);

      const result2 = stats.getScenes()[1].getTriggerTimes().filter((time) => { return time > 0 });
      expect(stats.getScenes()[1].getScene()).assertEqual(undefined);
      expect(result2.length).assertEqual(0);
    })

    /*
     * 测试场景:
     *   创建正常双条统计模块
     *   1. 循环传入慢速正常的统计场景1名称和时间直至统计条数满
     *   2. 循环传入慢速正常的统计场景2名称和时间直至统计条数满
     *   3. 传入慢速正常的统计场景1名称
     * 结果说明：
     *   统计并记录成功，场景1记录触发overflow覆盖；场景2记录没有影响
     */
    it('test_dual_scene_single_overflow_not_effect_others2', 0, () => {
      let stats = new HighFrequencyCallStatistics(2);
      /* 慢速填充 */
      const times = stats.getScenes()[0].getTriggerTimes().length;
      for (let i = 0; i < times; i++) {
        stats.record('test1', 100000 + i * 10000);
        stats.record('test2', 100000 + i * 11000);
      }
      stats.record('test1', 500000);

      const result2 = stats.getScenes()[1].getTriggerTimes().filter((time) => { return time > 0 });
      expect(stats.getScenes()[1].getScene()).assertEqual('test2');
      for (let i = 0; i < times; i++) {
        expect(result2[i]).assertEqual(100000 + i * 11000);
      }
    })

    /*
     * 测试场景:
     *   创建正常双条统计模块
     *   1. 传入慢速正常的统计场景1名称和时间
     *   2. 间隔一长段时间后，循环传入快速的统计场景2名称和时间直至触发告警
     * 结果说明：
     *   统计并记录成功，场景1记录被场景2抢占，场景2后被清空
     */
    it('test_dual_scene_warn_not_effect_others', 0, () => {
      let stats = new HighFrequencyCallStatistics(2);
      /* 这次先慢速填充不受影响的数据 */
      stats.record('test1', 100000);

      /* 快速触发另一组数据告警，注意，这里没有触发全量告警 */
      for (let i = 0; i < Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME + 1; i++) {
        stats.record('test2', 200000 + i * 100);
      }

      /* 注意这里test2添加的时候，test1是0频数据，导致test1被test2抢占，test再次清空后，没有数据 */
      const result1 = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      const result2 = stats.getScenes()[1].getTriggerTimes().filter((time) => { return time > 0 });
      expect(result1.length).assertEqual(0);
      expect(result2.length).assertEqual(0);
    })

    /*
     * 测试场景:
     *   创建正常双条统计模块
     *   1. 传入慢速正常的统计场景1名称和时间
     *   2. 循环传入快速的统计场景2名称和时间直至触发告警
     * 结果说明：
     *   统计并记录成功，场景1记录被场景2抢占，场景2后被清空
     */
    it('test_dual_scene_warn_not_effect_others2', 0, () => {
      let stats = new HighFrequencyCallStatistics(2);
      /* 这次先慢速填充不受影响的数据 */
      stats.record('test1', 100000);

      /* 快速触发另一组数据告警，注意，这里没有触发全量告警 */
      for (let i = 0; i < Statistics.MAX_CALL_FREQ * Statistics.FREQ_TIME + 1; i++) {
        stats.record('test2', 100000 + i * 100);
      }

      const result1 = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
      /* 注意 */
      expect(stats.getScenes()[0].getScene()).assertEqual('test1');
      expect(result1.length).assertEqual(1);
      expect(result1[0]).assertEqual(100000);
    })

    /*
     * 测试场景:
     *   创建正常双条统计模块
     *   1. 传入正常的统计场景1名称和时间
     *   2. 循环传入和第一步连续的快速的统计场景2名称和时间直至触发告警
     * 结果说明：
     *   统计并记录成功，记录触发告警，但由于是TOTAL告警，没有数据清空
     */
    it('test_dual_scene_total_warn', 0, () => {
      let stats = new HighFrequencyCallStatistics(2);
      /* 这次先慢速填充不受影响的数据 */
      stats.record('test1', 100000);
      let warn: boolean = false;
      /* 快速触发另一组数据告警，注意，这里没有触发全量告警 */
      for (let i = 1; i <= HighFrequencyCallStatistics.MAX_CALL_FREQ * HighFrequencyCallStatistics.FREQ_TIME; i++) {
        warn = stats.record('test2', 100000 + i * 100);
        if (i === HighFrequencyCallStatistics.MAX_CALL_FREQ * HighFrequencyCallStatistics.FREQ_TIME) {
          expect(warn).assertEqual(true);
        } else {
          expect(warn).assertEqual(false);
        }
        const result1 = stats.getScenes()[0].getTriggerTimes().filter((time) => { return time > 0 });
        const result2 = stats.getScenes()[1].getTriggerTimes().filter((time) => { return time > 0 });
        expect(result1.length).assertLarger(0);
        expect(result2.length).assertLarger(0);
      }
    })
  })
}
