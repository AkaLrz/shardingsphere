/*
 * Copyright 2016-2018 shardingsphere.io.
 * <p>
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
 * </p>
 */

package io.shardingsphere.example.repository.mybatis.repository;

import io.shardingsphere.example.repository.api.entity.Order;
import io.shardingsphere.example.repository.api.repository.Repository;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrderRepository extends Repository<Order> {
    
    @Override
    Long insert(Order entity);
    
    @Override
    List<Order> selectAll();
}
